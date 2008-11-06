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
	import com.adobe.crypto.SHA1;
	/**
	 * Test Cases for HMAC-MD5 and HMAC-SHA-1
	 * Implementation based on test cases description at 
	 * http://www.faqs.org/rfcs/rfc2202.html
	 */
	public class HMACSHA1Test extends TestCase
	{
		private var key:ByteArray;
		private var data:ByteArray;
		private var x:int;
		
		public function HMACSHA1Test( methodName:String = null) {
			super( methodName );
        }
		
		override public function setUp():void 
		{
			super.setUp();
			key = new ByteArray();
			data = new ByteArray();
		}
		
		public function test1():void {
			for ( x = 0; x < 20; x++ ) {
				key.writeByte(0x0b);
			}
			data.writeUTFBytes("Hi There");
			assertHMAC(key, data, "b617318655057264e28bc0b6fb378c8ef146be00");
		}
		
		public function test2():void {
			key.writeUTFBytes("Jefe");
			data.writeUTFBytes("what do ya want for nothing?");
			assertHMAC(key, data, "effcdf6ae5eb2fa2d27416d5f184df9c259a7c79");
		}
		
		public function test3():void {
			for ( x = 0; x < 20; x++ ) {
				key.writeByte(0xaa);
			}
			
			for ( x = 0; x < 50; x++ ) {
				data.writeByte(0xdd);
			}
			
			assertHMAC(key, data, "125d7342b9ac11cd91a39af48aa17b4f63f175d3");
		}
		
		public function test4():void {
			for ( x = 0; x < 25; x++ ) {
				key.writeByte( x + 1 );
			}
			
			for ( x = 0; x < 50; x++ ) {
				data.writeByte(0xcd);
			}
			
			assertHMAC(key, data, "4c9007f4026250c6bc8414f9bf50c86c2d7235da");
		}
		
		public function test5():void {
			for ( x = 0; x < 20; x++ ) {
				key.writeByte(0x0c);
			}
			
			data.writeUTFBytes("Test With Truncation");
			
			assertHMAC(key, data, "4c1a03424b55e07fe7f27be1d58bb9324a9a5a04");
		}
		
		public function test6():void {
			for ( x = 0; x < 80; x++ ) {
				key.writeByte( 0xaa );
			}
			
			data.writeUTFBytes("Test Using Larger Than Block-Size Key - Hash Key First");
			
			assertHMAC(key, data, "aa4ae5e15272d00e95705637ce8a3b55ed402112");
		}
		
		public function test7():void {
			for ( x = 0; x < 80; x++ ) {
				key.writeByte( 0xaa );
			}
			
			data.writeUTFBytes("Test Using Larger Than Block-Size Key and Larger Than One Block-Size Data");
			
			assertHMAC(key, data, "e8e99d0f45237d786d6bbaa7965c7808bbff1a91");
		}
		
		private function assertHMAC( key:ByteArray, value:ByteArray, expected:String):void {
			assertTrue( "Hash of '" + value.toString() + "' with key '" + key.toString() + "' returned wrong value ('" + HMAC.hashBytes(key,value,SHA1) + " ')",
						HMAC.hashBytes(key,value, SHA1) == expected );
		};
		
	}
	
}
