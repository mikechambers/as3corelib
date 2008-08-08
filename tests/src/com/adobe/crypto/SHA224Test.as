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
	
	import com.adobe.crypto.SHA256;
	
	public class SHA224Test extends TestCase {
		
	    public function SHA224Test( methodName:String = null ) {
			super( methodName );
        }
		
		public function testSHA224():void {
			
			// from the spec ( http://csrc.nist.gov/publications/fips/fips180-2/fips180-2withchangenotice.pdf )
			assertSHA224( "abc", "23097d223405d8228642a477bda255b32aadbce4bda0b3f7e36c9da7" );
			assertSHA224( "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq", "75388b16512776cc5dba5da1fd890150b0c6455cb4f58b1952522525" );
			
			var millionAs:String = new String("");
			for ( var i:int = 0; i < 1000000; i++ ) {
				millionAs += "a";
			}
			assertSHA224( millionAs, "20794655980c91d8bbb4c1ea97618a4bf03f42581948b2ee4ee7ad67" );
			
		}
		
		public function testSHA224Binary():void {
			
			// from the spec ( http://csrc.nist.gov/publications/fips/fips180-2/fips180-2withchangenotice.pdf )
			assertSHA224Binary( "abc", "23097d223405d8228642a477bda255b32aadbce4bda0b3f7e36c9da7" );
			assertSHA224Binary( "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq", "75388b16512776cc5dba5da1fd890150b0c6455cb4f58b1952522525" );
			
			var millionAs:String = new String("");
			for ( var i:int = 0; i < 1000000; i++ ) {
				millionAs += "a";
			}
			assertSHA224Binary( millionAs, "20794655980c91d8bbb4c1ea97618a4bf03f42581948b2ee4ee7ad67" );
		}
		
		public function testSHA224Base64():void {
			
		}
			
		private function assertSHA224( value:String, expected:String ):void {
			var result:String = SHA224.hash( value );
			
			assertTrue( "Hash of '" + value + "' returned wrong value ('" + result + "')",
						result == expected );
		}
		
		private function assertSHA224Binary(value:String, expected:String):void {
			
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeUTFBytes(value);
			
			var result:String = SHA224.hashBytes( byteArray );
			assertTrue( "Hash of '" + value + "' returned wrong value ('" + result + "')",
						result == expected );
		}
		
		private function assertSHA224Base64( value:String, expected:String ):void {
			var result:String = SHA224.hashToBase64( value );
			
			assertTrue( "Hash of '" + value + "' returned wrong value ('" + result + "')",
						result == expected );
		}
		
	}
}