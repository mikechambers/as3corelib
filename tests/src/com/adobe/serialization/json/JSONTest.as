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

package com.adobe.serialization.json
{

	import flexunit.framework.TestCase;
	
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
				//trace( parseError.message );
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

// Commented out - this is something that should only be available when "strict" is
// false.		
//		public function testDecodeHexNumber():void
//		{
//			var n:Number = JSON.decode( "0xFF0033" );
//			assertEquals( 0xFF0033, n );
//			
//			var parseError:JSONParseError = null;
//			try
//			{
//				n = JSON.decode( "0xZ" );
//			}
//			catch ( e:JSONParseError )
//			{
//				parseError = e;
//			}
//			finally
//			{
//				// Make sure we catch a parse error since 0xZ is an invalid number
//				assertNotNull( parseError );
//			}
//		}
		
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
			var o:Array = JSON.decode( "\n [ \nnull, \n \r \t \r true \n ] \r \t \r \n" ) as Array;
			
			assertTrue( "Expected decoded with newlines array[0] == null", o[0] == null );
			assertTrue( "Expected decoded with newlines array[1] == true", o[1] == true );
		}
		
		public function testDecodeSuccessiveComments():void
		{
			var jsonString:String = "   // test comment"
							+ "\n   // test comment line 2"
							+ "\nfalse";
			var o:* = JSON.decode( jsonString );
			assertEquals( false, o );
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
			
			o = JSON.encode( "myString" );
			assertEquals( o, "\"myString\"" );
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
			assertEquals( "Deeply nested", "{\"foo\":{\"foo2\":{\"foo3\":{\"foo4\":\"bar\"}}}}", s );
			
			obj = new Object();
			obj[" prop with spaces "] = true;
			s = JSON.encode( obj );
			assertEquals( "Prop with spaces", "{\" prop with spaces \":true}", s );
		}
		
		public function testEncodeClassInstance():void
		{
			var s:String = JSON.encode( new SimpleClass() );
			
			assertTrue( "Has length", s.length > 0 );

			// Decode the string so we can verify that it has the properties
			var o:Object = JSON.decode( s );

			assertNotNull( o );
			assertNotNull( o.publicVar1 );
			assertNotNull( o.publicVar2 );
			assertNotNull( o.accessor1 );
			assertNotNull( o.accessor2 );
			assertEquals( 17, o.publicVar1 );
			assertEquals( 20, o.publicVar2 );
			assertEquals( 25, o.accessor1 );
			assertEquals( 30, o.accessor2 );
			
			// Make sure o only has 4 properties
			var count:int = 0;
			for ( var key:String in o )
			{
				count++;	
			}
			assertEquals( 4, count );
		}
		
		public function testDecodeEmptyStringError():void
		{
			var e:Error = null;
			
			try
			{
				JSON.decode( "" );
			}
			catch ( pe:JSONParseError )
			{
				e = pe;
			}
			
			assertNotNull( e );
			assertTrue( "Caught parse error", e is JSONParseError );
		}
		
		public function testWhiteSpace():void
		{
			/*
			      ws = *(
                %x20 /              ; Space
                %x09 /              ; Horizontal tab
                %x0A /              ; Line feed or New line
                %x0D                ; Carriage return
            )
			*/
			
			//tabs
			var a_tab:String = "[\t1\t]";
			
			var a_tab_result:Array = JSON.decode(a_tab) as Array;
			
			assertEquals(a_tab_result[0], 1);
			
			
			//space
			var a_space:String = "[ 1 ]";
			
			var a_space_result:Array = JSON.decode(a_space) as Array;
			
			assertEquals(a_space_result[0], 1);
			
			//line return
			var a_lr:String = "[\n1\n]";

			var a_lr_result:Array = JSON.decode(a_lr) as Array;
			
			assertEquals(a_lr_result[0], 1);
			
			//carriage return
			var a_cr:String = "[\r1\r]";
			
			var a_cr_result:Array = JSON.decode(a_cr) as Array;
			
			assertEquals(a_cr_result[0], 1);
			
			//combined return
			var a_clr:String = "[\n\r1\n\r]";
			
			var a_clr_result:Array = JSON.decode(a_clr) as Array;
			
			assertEquals(a_clr_result[0], 1);
		}
		
		
	}
		
}
