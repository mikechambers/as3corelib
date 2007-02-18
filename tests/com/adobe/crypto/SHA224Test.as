/*
Adobe Systems Incorporated(r) Source Code License Agreement
Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
Please read this Source Code License Agreement carefully before using
the source code.
	
Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive,
no-charge, royalty-free, irrevocable copyright license, to reproduce,
prepare derivative works of, publicly display, publicly perform, and
distribute this source code and such derivative works in source or
object code form without any attribution requirements.
	
The name "Adobe Systems Incorporated" must not be used to endorse or promote products
derived from the source code without prior written permission.
	
You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
against any loss, damage, claims or lawsuits, including attorney's
fees that arise or result from your use or distribution of the source
code.
	
THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT
ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. ALSO, THERE IS NO WARRANTY OF
NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT. IN NO EVENT SHALL MACROMEDIA
OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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