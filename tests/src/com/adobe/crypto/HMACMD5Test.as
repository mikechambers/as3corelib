/*
  Copyright (c) 2008, Adobe Systems Incorporated
  All rights reserved.

  Redistribution and use in source and binary forms, with or without 
  modification, are permitted provided that the following conditions are
  met:

  * Redistributions of source code must retain the above copyright notice, 
    this list of conditions and the following disclaimer.
  
  * Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the 
    documentation and/or other materials provided with the distribution.
  
  * Neither the name of Adobe Systems Incorporated nor the names of its 
    contributors may be used to endorse or promote products derived from 
    this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package com.adobe.crypto  
{
	
	import flash.utils.ByteArray;
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import com.adobe.crypto.HMAC;
	
	public class HMACMD5Test extends TestCase
	{
		private var key:ByteArray;
		private var data:ByteArray;
		private var x:int;
		
		public function HMACMD5Test( methodName:String = null) {
			super( methodName );
        }
		
		override public function setUp():void 
		{
			super.setUp();
			key = new ByteArray();
			data = new ByteArray();
		}
		
		public function test1():void {
			for ( x = 0; x < 16; x++ ) {
				key.writeByte(0x0b);
			}
			data.writeUTFBytes("Hi There");
			assertHMAC(key, data, "9294727a3638bb1c13f48ef8158bfc9d");
		}
		
		public function test2():void {
			key.writeUTFBytes("Jefe");
			data.writeUTFBytes("what do ya want for nothing?");
			assertHMAC(key, data, "750c783e6ab0b503eaa86e310a5db738");
		}
		
		public function test3():void {
			for ( x = 0; x < 16; x++ ) {
				key.writeByte(0xaa);
			}
			
			for ( x = 0; x < 50; x++ ) {
				data.writeByte(0xdd);
			}
			
			assertHMAC(key, data, "56be34521d144c88dbb8c733f0e8b3f6");
		}
		
		public function test4():void {
			for ( x = 0; x < 25; x++ ) {
				key.writeByte( x + 1 );
			}
			
			for ( x = 0; x < 50; x++ ) {
				data.writeByte(0xcd);
			}
			
			assertHMAC(key, data, "697eaf0aca3a3aea3a75164746ffaa79");
		}
		
		public function test5():void {
			for ( x = 0; x < 16; x++ ) {
				key.writeByte(0x0c);
			}
			
			data.writeUTFBytes("Test With Truncation");
			
			assertHMAC(key, data, "56461ef2342edc00f9bab995690efd4c");
		}
		
		public function test6():void {
			for ( x = 0; x < 80; x++ ) {
				key.writeByte( 0xaa );
			}
			
			data.writeUTFBytes("Test Using Larger Than Block-Size Key - Hash Key First");
			
			assertHMAC(key, data, "6b1ab7fe4bd7bf8f0b62e6ce61b9d0cd");
		}
		
		public function test7():void {
			for ( x = 0; x < 80; x++ ) {
				key.writeByte( 0xaa );
			}
			
			data.writeUTFBytes("Test Using Larger Than Block-Size Key and Larger Than One Block-Size Data");
			
			assertHMAC(key, data, "6f630fad67cda0ee1fb1f562db3aa53e");
		}
		
		private function assertHMAC( key:ByteArray, value:ByteArray, expected:String):void {
			assertTrue( "Hash of '" + value.toString() + "' with key '" + key.toString() + "' returned wrong value ('" + HMAC.hashBytes(key,value) + " ')",
						HMAC.hashBytes(key,value) == expected );
		};
		
	}
	
}
