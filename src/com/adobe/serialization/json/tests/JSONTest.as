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

package com.adobe.serialization.json.tests {

	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import com.adobe.serialization.json.JSONDecoder;
	import com.adobe.serialization.json.JSONEncoder;
	import com.adobe.serialization.json.JSON;
	import com.adobe.serialization.json.JSONParseError;
	
	public class JSONTest extends TestCase {
		
	    public function JSONTest( methodName:String = null) {
			super( methodName );
        }
		
		/**
		 * Test for the JSON string true decoded to boolean true.
		 */
		public function testDecodeTrue():void {
			var o:* = JSON.decode( "  \n	 true  \n  " ) as Boolean;
			assertTrue( "Expected decoded true", o == true );
		}
		
		public function testDecodeFalse():void {
			var o:* = JSON.decode( "  	 false " ) as Boolean;
			assertTrue( "Expected decoded false", o == false );
		}
		
		public function testDecodeNull():void
		{
			var o:* = JSON.decode( "null " );
			assertTrue( "Expected decoded null", o == null );
		}
		
		public function testDecodeString():void
		{
			var o:* = JSON.decode( ' "this is \t a string \n with \' escapes" ' ) as String;
			assertTrue( "String not decoded successfully", o == "this is \t a string \n with \' escapes" );
			
			o = JSON.decode( ' "http:\/\/digg.com\/security\/Simple_Digg_Hack" ' );
			assertTrue( "String not decoded correctly", o == "http://digg.com/security/Simple_Digg_Hack" );
		}
		
		public function testDecodeZero():void
		{
			var n:Number = JSON.decode( "0" ) as Number;
			assertEquals( n, 0 );
		}
		
		public function testDecodeZeroWithDigitsAfterIt():void
		{
			var parseError:JSONParseError = null;
			try
			{
				var n:Number = JSON.decode( "02" ) as Number;
			}
			catch ( e:JSONParseError )
			{
				parseError = e;
			}
			finally
			{
				trace( parseError.message );
				assertNotNull( parseError );
			}
		}
		
		public function testDecodePositiveInt():void
		{
			var n:int = JSON.decode( "123871" ) as int;
			assertEquals( n, 123871 );
		}
		
		public function testDecodeNegativeInt():void
		{
			var n:int = JSON.decode( "-97123" ) as int;
			assertEquals( n, -97123 );
		}
		
		public function testDecodePositiveFloat():void
		{
			var n:Number = JSON.decode( "12.987324" ) as Number;
			assertEquals( n, 12.987324 );
		}
		
		public function testDecodeNegativeFloat():void
		{
			var n:Number = JSON.decode( "-1298.7324" ) as Number;
			assertEquals( n, -1298.7324 );
		}
		
		public function testDecodeFloatLeadingZeroError():void
		{
			var parseError:JSONParseError = null;
			try
			{
				var n:Number = JSON.decode( "-.2" ) as Number;
			}
			catch ( e:JSONParseError )
			{
				parseError = e;
			}
			finally
			{
				trace( parseError.message );
				assertNotNull( parseError );
			}
		}
		
		public function testDecodeFloatDecimalMissingError():void
		{
			var parseError:JSONParseError = null;
			try
			{
				var n:Number = JSON.decode( "1." );
			}
			catch ( e:JSONParseError )
			{
				parseError = e;
			}
			finally
			{
				// Make sure we caught a parse error since
				// there has to be numbers after the decimal
				assertNotNull( parseError );
			}
		}
		
		public function testDecodeScientificRegularExponent():void
		{
			var n:Number = JSON.decode( "6.02e2" ) as Number;
			assertEquals( n, 602 );
			
			n = JSON.decode( "-2e10" );			
			assertEquals( n, -20000000000 ); 
			assertEquals( n, -2 * Math.pow( 10, 10 ) );
		}
		
		public function testDecodeScientificPositiveExponent():void
		{
			var n:Number = JSON.decode( "2E+9" ) as Number;
			assertEquals( n, 2 * Math.pow( 10, 9 ) );
			
			n = JSON.decode( "-2.2E+23" ) as Number;
			assertEquals( n, -2.2 * Math.pow( 10, 23 ) );
		}
		
		public function testDecodeScientificNegativeExponent():void
		{
			var n:Number = JSON.decode( "6.02e-23" ) as Number;
			assertEquals( n, 6.02 * Math.pow( 10, -23 ) ); 
			
			n = JSON.decode( "-4e-9" ) as Number;
			assertEquals( n, -4 * Math.pow( 10, -9 ) ); 
			
			n = JSON.decode( "0E-2" ) as Number;
			assertEquals( n, 0 );
		}
		
		public function testDecodeScientificExonentError():void
		{
			var parseError:JSONParseError = null;
			try
			{
				var n:Number = JSON.decode( "1e" );
			}
			catch ( e:JSONParseError )
			{
				parseError = e;
			}
			finally
			{
				// Make sure we caught a parse error since
				// there has to be numbers after the e
				assertNotNull( parseError );
			}
		}
		
		public function testDecodeObject():void {
			var o:* = JSON.decode( " { \"test\": true, \"test2\": -12356732.12 } " ) as Object;
			assertTrue( "Expected decoded object.test = true", o.test == true );
			assertTrue( "Expected decoded object.test2 = -12356732.12", o.test2 == -12356732.12 );
		}
		
		public function testDecodeArray():void {
			var o:* = JSON.decode( " [ null, true, false, 100, -100, \"test\", { \"foo\": \"bar\" } ] "  ) as Array;
			assertTrue( "Expected decoded array[0] == null", o[0] == null );
			assertTrue( "Expected decoded array[1] == true", o[1] == true );
			assertTrue( "Expected decoded array[2] == false", o[2] == false );
			assertTrue( "Expected decoded array[3] == 100", o[3] == 100 );
			assertTrue( "Expected decoded array[4] == -100", o[4] == -100 );
			assertTrue( "Expected decoded array[5] == \"test\"", o[5] == "test" );
			assertTrue( "Expected decoded array[6].foo == \"bar\"", o[6].foo == "bar" );
		}
		
		public function testDecodeArrayWithNewlines():void {
			var o:Array = JSON.decode( "\n [ \nnull, \n true \n ] \n" ) as Array;
			
			assertTrue( "Expected decoded with newlines array[0] == null", o[0] == null );
			assertTrue( "Expected decoded with newlines array[1] == true", o[1] == true );
		}
		
		public function testEncodeTrue():void {
			var o:String = JSON.encode( true );
			assertTrue( "Expected encoded true", o == "true" );
		}
		
		public function testEncodeFalse():void {
			var o:String = JSON.encode( false );
			assertTrue( "Expected encoded false", o == "false" );
		}
		
		public function testEncodeNull():void {
			var o:String = JSON.encode( null );
			assertTrue( "Expected encoded null", o == "null" );
		}
		
		public function testEncodeString():void {
			var o:String = JSON.encode( "this is a \n \"string\"" );
			assertTrue( "Expected encoded string", o == "\"this is a \\n \\\"string\\\"\"" );
		}
		
		public function testEncodeArrayEmpty():void {
			var o:String = JSON.encode( [] );
			assertTrue( "Expected encoded []", o == "[]" );
		}
		
		public function testEncodeArray():void {
			var o:String = JSON.encode( [ true, false, -10, null, Number.NEGATIVE_INFINITY ] );
			assertTrue( "Expected encoded array", o == "[true,false,-10,null,null]" );
		}
		
		public function testEncodeObjectEmpty():void {
			var o:String = JSON.encode( {} );
			assertTrue( "Expected encoded {}", o == "{}" );
		}
		
		public function testEncodeObject():void {
			// Note: because order cannot be guaranteed when decoding
			// into a string, we can't reliably test an object with
			// multiple properties, so instead we test multiple
			// smaller objects
			//var obj:Object = new Object();
			//obj.test1 = true;
			//obj["test 2"] = false;
			//obj[" test _3" ] = { foo: "bar" };
			
			//var o:String = JSON.encode( obj );
			//assertTrue( "Expected encoded object", o == "{\"test1\":true,\"test 2\":false,\" test _3\":{\"foo\":\"bar\"}}" );
			
			var obj:Object = { foo: { foo2: { foo3: { foo4: "bar" } } } };
			var s:String = JSON.encode( obj );
			assertTrue( "Deeply nested", "{\"foo\":{\"foo2\":{\"foo3\":{\"foo4\":\"bar\"}}}}" );
			
			obj = new Object();
			obj[" prop with spaces "] = true;
			assertTrue( "Prop with spaces", "{\" prop with spaces \":true}" );
		}
	}
		
}
