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
	/**
	 * Convert a String or ByteArray from a JSON-encoded object to an actual
	 * object. It's better to supply a ByteArray, if possible, since a String will
	 * be converted to a ByteArray anyway. Keep in mind the endian or position of
	 * a ByteArray will not be preserved. Data in the ByteArray will not be
	 * modified.
	 *
	 * This should be compatible with all valid JSON, and may parse some kinds
	 * invalid JSON, but generally this is very strict.
	 *
	 * @parameter input A JSON-encoded ByteArray or String.
	 * @return The object created by the JSON decoding.
	 * @see http://json.org/
	 */
	public const decodeJson:Function = initDecodeJson();
}

import flash.utils.ByteArray;

function initDecodeJson():Function {
	var position:uint;
	var byteInput:ByteArray;
	var char:uint;
	var strPosition:uint;
	const str:ByteArray = new ByteArray();

	const charConvert:ByteArray = new ByteArray();
	charConvert.length = 0x100;// fill w/ 0's
	charConvert[0x22] = 0x22;// \" -> "
	charConvert[0x5c] = 0x5c;// \\ -> \
	charConvert[0x2f] = 0x2f;// \/ -> /
	charConvert[0x62] = 0x8;// \b -> backspace
	charConvert[0x66] = 0xc;// \f -> formfeed
	charConvert[0x6e] = 0xa;// \n -> newline
	charConvert[0x72] = 0xd;// \r -> carriage return
	charConvert[0x74] = 0x9;// \t -> horizontal tab

	const isNumberChar:ByteArray = new ByteArray();
	isNumberChar.length = 0x100;// fill w/ 0's
	isNumberChar[0x2b] = 1;// +
	isNumberChar[0x2d] = 1;// -
	isNumberChar[0x2e] = 1;// .
	isNumberChar[0x30] = 1;// 0
	isNumberChar[0x31] = 1;// 1
	isNumberChar[0x32] = 1;// 2
	isNumberChar[0x33] = 1;// 3
	isNumberChar[0x34] = 1;// 4
	isNumberChar[0x35] = 1;// 5
	isNumberChar[0x36] = 1;// 6
	isNumberChar[0x37] = 1;// 7
	isNumberChar[0x38] = 1;// 8
	isNumberChar[0x39] = 1;// 9
	isNumberChar[0x45] = 1;// E
	isNumberChar[0x65] = 1;// e

	const parseNumber:Function = function():Number {
		var result:Number;
		if (position === 1) {
			// read the rest of the input as a number
			byteInput.position = 0;
			result = parseFloat(byteInput.readUTFBytes(byteInput.length));
			if (isNaN(result)) {
				throw new Error("Expected number at position 0");
			}
		} else {
			// parsing an object or array
			// ], }, or , will be at end of the number
			strPosition = --position;
			while (isNumberChar[byteInput[position++]]) {};
			byteInput.position = strPosition;
			result = Number(byteInput.readUTFBytes(position - strPosition - 1));
			position = byteInput.position;
			if (isNaN(result)) {
				throw new Error("Expected number at position " + (strPosition - 1));
			}
		}
		return result;
	};

	const parseWhitespace:Function = function():Object {
		while (byteInput[position] === 0x20 || byteInput[position] === 0xd ||
			byteInput[position] === 0xa || byteInput[position] === 0x9) {// == " ", \r, \n, \t
			position++;
		}
		return parse[byteInput[position++]]();
	};

	const skipWhitespace:Function = function():int {
		while (byteInput[position] === 0x20 || byteInput[position] === 0xd ||
			byteInput[position] === 0xa || byteInput[position] === 0x9) {// == " ", \r, \n, \t
			position++;
		}
		return byteInput[position++];
	};

	// parse is a mapping of the first character of what's being parsed, to the
	// function that parses it
	const parse:Object = {
		0x22: function ():String {// "
			// parse a string
			strPosition = position;
			str.position = 0;
			str.length = 0;
			while ((char = byteInput[strPosition++]) !== 0x22) {// != "
				// all non-ascii utf8 bytes have the last bit (0x80) set,
				// so this code works for ascii and valid utf8
				if (char === 0x5c) {// == \
					// flush the buffered data to the result
					if ((strPosition - 1) > position) {
						byteInput.position = position;
						byteInput.readBytes(str, str.position, (strPosition - 1) - position);
						str.position = str.length;
						position = strPosition = ++byteInput.position;
					}

					// which special character is it?
					if ((char = byteInput[strPosition++]) === 0x75) {// \uxxxx -> utf8 char
						byteInput.position = strPosition;
						char = parseInt(byteInput.readUTFBytes(4), 16);
						// write the new character out as utf8
						if (char <= 0x7f) {
							str.writeByte(char);
						} else if (char < 0x7ff) {
							str.writeShort(0xC080 |
								((char << 2) & 0x1f00) | (char & 0x3f));
						} else {
							str.writeByte(0xE0 | ((char >> 12) & 0xf));
							str.writeShort(0x8080 |
								((char << 2) & 0x3f00) | (char & 0x3f));
						}
						position = strPosition = byteInput.position;
						continue;
					} else if (!(char = charConvert[char])) {
						throw new Error(
							"Unknown escaped character encountered at position " +
							(strPosition - 1));
					}

					// write special character to result
					str.position = str.length;
					str.writeByte(char);
					position = strPosition;
				}
			}
			if (str.length > 0) {
				// copy rest of string to result
				if ((strPosition - 1) > position) {
					byteInput.position = position;
					byteInput.readBytes(
						str, str.position, (strPosition - 1) - position);
					byteInput.position++;
				}

				// prepare result
				position = strPosition;
				str.position = 0;
				return str.readUTFBytes(str.length);
			} else {
				// copy entire string to result
				byteInput.position = position;
				// swap strPosition and position
				position = strPosition;
				strPosition = byteInput.position;
				return byteInput.readUTFBytes((position - 1) - strPosition);
			}
		},
		0x7b: function ():Object {// {
			if (skipWhitespace() === 0x7d) {// == }
				return {};
			}

			var result:Object = {};
			var key:String;
			position--;
			do {
				do {
					key = parse[byteInput[position++]]();
					if (byteInput[position] !== 0x3a) {
						if (skipWhitespace() !== 0x3a) {
							throw new Error("Expected : at " + (position - 1));
						}
					} else {
						position++;
					}
					result[key] = parse[byteInput[position++]]();
				} while (byteInput[position++] === 0x2c);// == ,
				if (byteInput[position - 1] === 0x7d) {// != }
					return result;
				}
			} while (skipWhitespace() === 0x2c);// == ,
			if (byteInput[position - 1] !== 0x7d) {// != }
				throw new Error("Expected , or } at " + (position - 1));
			}
			return result;
		},
		0x5b: function ():Object {// [
			if (skipWhitespace() === 0x5d) {// == ]
				return [];
			}

			var result:Array = [];
			position--;
			do {
				do {
					result[result.length] = parse[byteInput[position++]]();
				} while (byteInput[position++] === 0x2c);// == ,
				if (byteInput[position - 1] === 0x5d) {// != ]
					return result;
				}
				position--;
			} while (skipWhitespace() === 0x2c);
			if (byteInput[position - 1] !== 0x5d) {
				throw new Error("Expected , or ] at " + (position - 1));
			}
			return result;
		},
		0x74: function ():Boolean {// t
			byteInput.position = position - 1;
			if (byteInput.readInt() === 0x74727565) {// == true
				position = byteInput.position;
				return true;
			}
			throw new Error("Expected \"true\" at position " + position);
		},
		0x66: function ():Boolean {// f
			byteInput.position = position;
			if (byteInput.readInt() === 0x616c7365) {// == alse
				position = byteInput.position;
				return false;
			}
			throw new Error("Expected \"false\" at position " + (position - 1));
		},
		0x6e: function ():Object {// n
			byteInput.position = position - 1;
			if (byteInput.readInt() === 0x6e756c6c) {// == null
				position = byteInput.position;
				return null;
			}
			throw new Error("Expected \"null\" at position " + position);
		},
		0x6e: function ():void {// ]
			throw new Error("Unexpected end of array at " + position);
		},
		0x7d: function ():void {// }
			throw new Error("Unexpected end of object at " + position);
		},
		0x2c: function ():void {// ,
			throw new Error("Unexpected comma at " + position);
		},
		0x2d: parseNumber,// -
		0x30: parseNumber,// 0
		0x31: parseNumber,// 1
		0x32: parseNumber,// 2
		0x33: parseNumber,// 3
		0x34: parseNumber,// 4
		0x35: parseNumber,// 5
		0x36: parseNumber,// 6
		0x37: parseNumber,// 7
		0x38: parseNumber,// 8
		0x39: parseNumber,// 9
		0xd: parseWhitespace,// \r
		0xa: parseWhitespace,// \n
		0x9: parseWhitespace,// \t
		0x20: parseWhitespace// " "
	};

	return function (input:*):Object {
		// prepare the input
		if (input is String) {
			byteInput = new ByteArray();
			byteInput.writeUTFBytes(input as String);
		} else if (input is ByteArray) {
			byteInput = input as ByteArray;
		} else {
			throw new Error("Unexpected input <" + input + ">");
		}
		byteInput.position = position = 0;
		byteInput.endian = "bigEndian";

		try {
			return parse[byteInput[position++]]();
		} catch (e:TypeError) {
			if (position - 1 < byteInput.length) {
				throw new Error(
					"Internal Stack Trace: " + (e.getStackTrace() || e.message) +
					"\n\nExternal Stack Trace: Unexpected character " +
					String.fromCharCode(byteInput[position - 1]) +
					" (0x" + byteInput[position - 1].toString(16) + ")" +
					" at position " + (position - 1));
			} else {
				throw e;
			}
		} finally {
			// cleanup
			str.length = 0;
		}
		return null;
	}
}
