/*
 * Copyright 2010 Maximilian Herkender
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.brokenfunction.json {
	import flash.utils.ByteArray;
	import flash.utils.IDataOutput;

	/**
	 * An asynchronous JSON encoder.
	 * @see http://json.org/
	 */
	public class JsonEncoderAsync {
		private static var _charConvert:Array;

		private var _output:IDataOutput;
		private var _byteOutput:ByteArray;
		private var _tempBytes:ByteArray = new ByteArray();

		/**
		 * This is the function to execute to continue processing. If it is null
		 * there is nothing left to process. Functions modify stackTop to set what
		 * must be processed next.
		 * @private
		 */
		private var stackTop:Function;

		/**
		 * @parameter input An object to convert to JSON.
		 * @parameter writeTo An optional IDataOutput output stream to write data to.
		 * @see http://json.org/
		 */
		public function JsonEncoderAsync(input:*, writeTo:IDataOutput = null):void {
			// prepare the input
			if (writeTo) {
				_output = writeTo;
			} else {
				_output = _byteOutput = new ByteArray();
			}
			_output.endian = "bigEndian";

			// conversions for escaped characters
			if (!_charConvert) {
				_charConvert = new Array(0x100);
				for (var j:int = 0; j < 0x100; j++) {
					_charConvert[j] = j;
				}
				_charConvert[0xa] = 0x5c6e; // \n
				_charConvert[0xd] = 0x5c72; // \r
				_charConvert[0x9] = 0x5c74; // \t
				_charConvert[0x8] = 0x5c62; // \b
				_charConvert[0xc] = 0x5c66; // \f
				_charConvert[0x8] = 0x5c62; // \b
				_charConvert[0x22] = 0x5c22; // \"
				_charConvert[0x5c] = 0x5c5c; // \\
				// not necessary for valid json
				//_charConvert[0x2f] = 0x5c2f; // \/
			}

			// the initial stack function
			stackTop = function ():void {
				stackTop = null;
				parseValue(input);
			}
		}

		/**
		 * A valid JSON-encoded string if writeTo is not specified, otherwise
	   * this will throw an error.
		 */
		public function get result():String {
			if (!_byteOutput) {
				throw new Error("No result available when writeTo is used.");
			}
			if (stackTop != null) {
				process();
			}
			_byteOutput.position = 0;
			return _byteOutput.readUTFBytes(_byteOutput.length);
		}

		/**
		 * Continue processing data. Warning, there are currently no limits placed
		 * on string processing.
		 *
		 * @property limit Stop processing after this many chunks of data. Because
		 * of limitations in Flash, it isn't very strict, and depends on the data
		 * being processed. Find a number that works. If zero, process will continue
		 * until there is nothing left to be processed
		 * @return True if processing is finished, otherwise process will return
		 * false.
		 */
		public function process(limit:uint = 0):Boolean {
			if (limit) {
				while (stackTop != null) {
					stackTop();
					if (limit-- > 0) {
						return false;
					}
				}
			} else {
				while (stackTop != null) {
					stackTop();
				}
			}
			return true;
		}

		private function parseValue(input:*):void {
			switch (typeof input) {
				case "object":
					if (input) {
						if (input is Array) {
							parseArray(input);
						} else {
							parseObject(input);
						}
					} else {
						_output.writeUnsignedInt(0x6e756c6c);// null
					}
					return;
				case "string":
					parseString(input);
					return;
				case "number":
					_output.writeUTFBytes(String(input));
					return;
				case "boolean":
					if (input) {
						_output.writeUnsignedInt(0x74727565);// true
					} else {
						_output.writeByte(0x66);// f
						_output.writeUnsignedInt(0x616c7365);// alse
					}
					return;
				case "undefined":
					_output.writeUnsignedInt(0x6e756c6c);// null
					return;
			};
		}

		private function parseArray(input:Array):void {
			_output.writeByte(0x5b);// [

			var stackNext:Function = stackTop;
			var length:int = input.length;
			if (length >= 2) {
				var pos:int = 1;
				stackTop = function ():void {// parse values 1-n
					_output.writeByte(0x2c);// ,
					if (pos >= length - 1) {
						stackTop = function ():void {// end processing
							stackTop = stackNext;
							_output.writeByte(0x5d);// ]
						}
					}
					parseValue(input[pos++]);
				}
				parseValue(input[0]);
			} else if (length >= 1) {
				stackTop = function ():void {// end processing
					stackTop = stackNext;
					_output.writeByte(0x5d);// ]
				}
				parseValue(input[0]);
			} else {
				_output.writeByte(0x5d);// ]
			}
		}

		private function parseObject(input:Object):void {
			_output.writeByte(0x7b);// {

			var stackNext:Function = stackTop;
			var keys:Array = [];
			for (var i:String in input) {
				keys[keys.length] = i;
			}
			var length:int = keys.length;
			if (length >= 2) {
				var pos:int = 1;
				var value:Function = function ():void {// process an object value
					if (pos >= length - 1) {
						stackTop = function ():void {// end processing
							stackTop = stackNext;
							_output.writeByte(0x7d);// }
						}
					} else {
						stackTop = key;
					}
					_output.writeByte(0x3a);// :
					parseValue(input[keys[pos++]]);
				}
				var key:Function = function ():void {// process an object key after a value
					stackTop = value
					_output.writeByte(0x2c);// ,
					parseString(keys[pos]);
				}
				stackTop = function ():void {// process first object key
					stackTop = key;
					_output.writeByte(0x3a);// :
					parseValue(input[keys[0]]);
				}
				parseString(keys[0]);
			} else if (length >= 1) {
				stackTop = function ():void {// process only object key
					stackTop = function ():void {// process only object value
						_output.writeByte(0x7d);// }
						stackTop = stackNext;
					}
					_output.writeByte(0x3a);// :
					parseValue(input[keys[pos]]);
				}
				parseString(keys[0]);
			} else {
				_output.writeByte(0x7d);// }
			}
		}

		private function parseString(input:String):void {
			_output.writeByte(0x22);// "
			_tempBytes.position = 0;
			_tempBytes.length = 0;
			_tempBytes.writeUTFBytes(input);
			var i:int = 0, j:int = 0, char:int;
			var strLen:int = _tempBytes.length;
			strloop:while (j < strLen) {
				char = _charConvert[_tempBytes[j++]];
				if (char > 0x100) {
					if (j - 1 > i) {
						// flush buffered string
						_output.writeBytes(_tempBytes, i, (j - 1) - i);
					}
					_output.writeShort(char);
					i = j;
				}
			}
			// flush the rest of the string
			if (strLen > i) {
				_output.writeBytes(_tempBytes, i, strLen - i);
			}
			_output.writeByte(0x22);// "
		}
	}
}
