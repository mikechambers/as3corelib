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

package com.adobe.air.crypto
{

	import flash.data.EncryptedLocalStore;
	import flash.utils.ByteArray;
	
	import flexunit.framework.TestCase;
	
	import mx.utils.Base64Encoder;
	
	public class EncryptionKeyGeneratorTest extends TestCase {
		
		private const ELS_KEY:String = "EncryptionKeyGeneratorTest";
		private const DEFAULT_ELS_KEY:String = "com.adobe.air.crypto::EncryptedDBSalt$$$";
		
	    public function EncryptionKeyGeneratorTest( methodName:String = null ) {
			super( methodName );
        }
		
		override public function setUp():void
		{
			var salt:ByteArray = new ByteArray();
			salt.writeUnsignedInt(1989196088);
			salt.writeUnsignedInt(4188830919);
			salt.writeUnsignedInt(3631556863);
			salt.writeUnsignedInt(2543121849);
			salt.writeUnsignedInt(3166585847);
			salt.writeUnsignedInt(4225038051);
			salt.writeUnsignedInt(3182011233);
			salt.writeUnsignedInt(152503506);

			EncryptedLocalStore.setItem(ELS_KEY, salt);
		}
		
		override public function tearDown():void
		{
			EncryptedLocalStore.removeItem(ELS_KEY);
			EncryptedLocalStore.removeItem(DEFAULT_ELS_KEY);
		}
		
		public function test_validateStrongPassword():void
		{
			var keyGen:EncryptionKeyGenerator = new EncryptionKeyGenerator();
			assertTrue(keyGen.validateStrongPassword("ABcd95$bal"));
			assertFalse(keyGen.validateStrongPassword("password"));
			assertFalse(keyGen.validateStrongPassword("PassWord"));
			assertTrue(keyGen.validateStrongPassword("pa$$Word"));
		}
		
		public function test_getEncryptionKey():void
		{
			var keyGen:EncryptionKeyGenerator = new EncryptionKeyGenerator();
			var encoder:Base64Encoder = new Base64Encoder();
			encoder.encodeBytes(keyGen.getEncryptionKey("pa$$Word", ELS_KEY));
			assertEquals(encoder.toString(), "oy1N2GAxVFC7vCa0A2wP+Q==");
		}
		
		public function test_getEncryptionKeyAgain():void
		{
			var keyGen:EncryptionKeyGenerator = new EncryptionKeyGenerator();
			var attempt1:ByteArray = keyGen.getEncryptionKey("ABcd95$bal");
			var attempt2:ByteArray = keyGen.getEncryptionKey("ABcd95$bal");
			
			var encoder1:Base64Encoder = new Base64Encoder();
			encoder1.encodeBytes(attempt1);
			var encoder2:Base64Encoder = new Base64Encoder();
			encoder2.encodeBytes(attempt2);
			
			assertEquals(encoder1.toString(), encoder2.toString());
		}





//		public function testSHA256():void {
//			
//			
//			// from the spec ( http://csrc.nist.gov/publications/fips/fips180-2/fips180-2withchangenotice.pdf )
//			assertSHA256( "abc", "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad" );
//			assertSHA256( "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq", "248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1");
//			
//			var millionAs:String = new String("");
//			for ( var i:int = 0; i < 1000000; i++ ) {
//				millionAs += "a";
//			}
//			assertSHA256( millionAs, "cdc76e5c9914fb9281a1c7e284d73e67f1809a48a497200e046d39ccc7112cd0" );
//			
//			// from wikipedia
//			assertSHA256( "The quick brown fox jumps over the lazy dog", "d7a8fbb307d7809469ca9abcb0082e4f8d5651e46d3cdb762d02d0bf37c9e592" );
//			assertSHA256( "The quick brown fox jumps over the lazy cog", "e4c4d8f3bf76b692de791a173e05321150f7a345b46484fe427f6acc7ecc81be" );
//			assertSHA256( "", "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855" );
//			
//		}
//		
//		public function testSHA256Binary():void {
//			
//			// from the spec ( http://csrc.nist.gov/publications/fips/fips180-2/fips180-2withchangenotice.pdf )
//			assertSHA256Binary( "abc", "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad" );
//			assertSHA256Binary( "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq", "248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1");
//			
//			var millionAs:String = new String("");
//			for ( var i:int = 0; i < 1000000; i++ ) {
//				millionAs += "a";
//			}
//			assertSHA256Binary( millionAs, "cdc76e5c9914fb9281a1c7e284d73e67f1809a48a497200e046d39ccc7112cd0" );
//			
//			// from wikipedia
//			assertSHA256Binary( "The quick brown fox jumps over the lazy dog", "d7a8fbb307d7809469ca9abcb0082e4f8d5651e46d3cdb762d02d0bf37c9e592" );
//			assertSHA256Binary( "The quick brown fox jumps over the lazy cog", "e4c4d8f3bf76b692de791a173e05321150f7a345b46484fe427f6acc7ecc81be" );
//			assertSHA256Binary( "", "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855" );
//			
//		}
//		
//		public function testSHA256Base64():void {
//			
//		}
//			
//		private function assertSHA256( value:String, expected:String ):void {
//			var result:String = SHA256.hash( value );
//			
//			assertTrue( "Hash of '" + value + "' returned wrong value ('" + result + "')",
//						result == expected );
//		}
//		
//		private function assertSHA256Binary(value:String, expected:String):void {
//			
//			var byteArray:ByteArray = new ByteArray();
//			byteArray.writeUTFBytes(value);
//			
//			var result:String = SHA256.hashBytes( byteArray );
//			assertTrue( "Hash of '" + value + "' returned wrong value ('" + result + "')",
//						result == expected );
//		}
//		
//		private function assertSHA256Base64( value:String, expected:String ):void {
//			var result:String = SHA256.hashToBase64( value );
//			
//			assertTrue( "Hash of '" + value + "' returned wrong value ('" + result + "')",
//						result == expected );
//		}
//		
	}
}