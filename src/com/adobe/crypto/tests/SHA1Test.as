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

package com.adobe.crypto.tests {

	import flash.utils.ByteArray;
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import com.adobe.crypto.SHA1;
	import com.adobe.utils.IntUtil;
	
	public class SHA1Test extends TestCase {
		
	    public function SHA1Test( methodName:String = null ) {
			super( methodName );
        }
		
		public function testSHA1():void {
		
			assertSHA1( "abc", "a9993e364706816aba3e25717850c26c9cd0d89d" );
			
			assertSHA1( "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq",
						"84983e441c3bd26ebaae4aa1f95129e5e54670f1" );
			
			assertSHA1( "The quick brown fox jumps over the lazy dog", 
						"2fd4e1c67a2d28fced849ee1bb76e7391b93eb12" );
						
			assertSHA1( "The quick brown fox jumps over the lazy cog", 
						"de9f2c7fd25e1b3afad3e85a0bd17d9b100db4b3" );
						
			assertSHA1( "", 
						"da39a3ee5e6b4b0d3255bfef95601890afd80709" );

			assertSHA1( "d36e316282959a9ed4c89851497a717f2003-12-15T14:43:07Ztaadtaadpstcsm",
						"aae47f1162c0578c4b7fd66acb0e290e67d5f4e6" );				 
						
			var millionAs:String = new String("");
			for ( var i:int = 0; i < 1000000; i++ ) {
				millionAs += "a";
			}
			assertSHA1( millionAs, "34aa973cd4c4daa4f61eeb2bdbad27316534016f" );
		}
		
		public function testSHA1Base64():void {
			assertSHA1Base64( "abc", "qZk+NkcGgWq6PiVxeFDCbJzQ2J0=" );
		
			assertSHA1Base64( "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq",
							  "hJg+RBw70m66rkqh+VEp5eVGcPE=");
							  
			assertSHA1Base64( "The quick brown fox jumps over the lazy dog", 
							  "L9ThxnotKPzthJ7hu3bnORuT6xI=" );

			assertSHA1Base64( "The quick brown fox jumps over the lazy cog", 
							  "3p8sf9JeGzr60+haC9F9mxANtLM=" );

			assertSHA1Base64( "", 
							  "2jmj7l5rSw0yVb/vlWAYkK/YBwk=" );

			assertSHA1Base64( "d36e316282959a9ed4c89851497a717f2003-12-15T14:43:07Ztaadtaadpstcsm",
							  "quR/EWLAV4xLf9Zqyw4pDmfV9OY=" );
			
			var millionAs:String = new String("");
			for ( var i:int = 0; i < 1000000; i++ ) {
				millionAs += "a";
			}
			assertSHA1Base64( millionAs, "NKqXPNTE2qT2Husr260nMWU0AW8=" );
		}
			
		private function assertSHA1( value:String, expected:String ):void {
			var result:String = SHA1.hash( value );
			
			assertTrue( "Hash of '" + value + "' returned wrong value ('" + result + "')",
						result == expected );
		}
		
		private function assertSHA1Base64( value:String, expected:String ):void {
			var result:String = SHA1.hashToBase64( value );
			
			assertTrue( "Hash of '" + value + "' returned wrong value ('" + result + "')",
						result == expected );
		}
		
	}
}