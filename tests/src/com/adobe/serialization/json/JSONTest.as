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
	
	public class JSONTest extends TestCase
	{
		
	    public function JSONTest( methodName:String = null )
	    {
			super( methodName );
        }
        
        /**
		 * Helper method to verify whether or not a given input correctly
		 * throws a JSONParseError
		 */
		protected function expectParseError( jsonString:String, strict:Boolean = true ):void
		{
			var parseError:JSONParseError = null;
			
			try
			{
				var o:* = JSON.decode( jsonString, strict );
				fail( "Expecting parse error but one was not thrown" );
			}
			catch ( e:JSONParseError )
			{
				parseError = e;
			}
			catch ( e:Error )
			{
				throw e;
			}
			
			// Make sure we catch a parse error since 0xZ is an invalid number
			assertNotNull( parseError );
		}
		
		/**
		 * Test for the JSON string true decoded to boolean true.
		 */
		public function testDecodeTrue():void
		{
			var o:* = JSON.decode( "true" ) as Boolean;
			assertTrue( "Expected decoded true", o );
		}
		
		public function testDecodeFalse():void
		{
			var o:* = JSON.decode( "false" ) as Boolean;
			assertFalse( "Expected decoded false", o );
		}
		
		public function testDecodeNull():void
		{
			var o:* = JSON.decode( "null " );
			assertNull( "Expected decoded null", o );
		}
		
		public function testDecodeString():void
		{
			var string:String = "this \"is\" \t a \/ string \b \f \r \h \\ \n with \' ch\\u0061rs that should be { } http://escaped.com/";
			assertEquals( string, JSON.decode( JSON.encode( string ) ) );
			
			var o:String = JSON.decode( "\"http:\/\/digg.com\/security\/Simple_Digg_Hack\"" ) as String;
			assertEquals( "String not decoded correctly", "http://digg.com/security/Simple_Digg_Hack", o );
			
			expectParseError( "\"unterminated string" );
		}
		
		public function testDecodeStringWithInvalidUnicodeEscape():void
		{
			// No characters after the u
			expectParseError( "\"\\u\"" );
			
			// Not a hex character after the u
			expectParseError( "\"\\ut\"" );
			
			// Not enough characters after the u
			expectParseError( "\"\\u123\"" );
			
			// Unicode decodes correctly
			assertEquals( "a", JSON.decode( "\"\\u0061\"" ) );
		}
		
		// Issue #104 - http://code.google.com/p/as3corelib/issues/detail?id=104
		public function testDecodeStringWithControlCharacters():void
		{
			var i:int;
			
			// In strict mode, we expect an error when we try to decode a string that
			// contains unescaped control characters.
			for ( i = 0x00; i <= 0x1F; i++ )
			{
				expectParseError( "\"string with control char " + i + ": " + String.fromCharCode( i ) + "\"", true );	
			}
			
			// In non-strict mode, we don't expect any errors
			for ( i = 0x00; i <= 0x1F; i++ )
			{
				var string:String = "control char " + i + ": " + String.fromCharCode( i ) + ""
				assertEquals( string,
							JSON.decode( "\"" + string + "\"", false ) );
			}
		}
		
		public function testDecodeZero():void
		{
			var n:Number = JSON.decode( "0" ) as Number;
			assertEquals( n, 0 );
		}
		
		public function testDecodeZeroWithDigitsAfterIt():void
		{
			expectParseError( "02" );
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
			expectParseError( "-.2" );
		}
		
		public function testDecodeFloatDecimalMissingError():void
		{
			expectParseError( "1." );
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
		
		public function testDecodeScientificExponentError():void
		{
			expectParseError( "1e" );
		}

		/**
		 * In non-strict mode, we can interpret hex values as numbers
		 */
		public function testDecodeHex():void
		{
			var n:Number = JSON.decode( "0xFF0033", false );
			assertEquals( 0xFF0033, n );
			
			// Verify invalid hex format throws error
			expectParseError( "0x", false );
			
			// Verify invalid hex format throws error
			expectParseError( "0xZ", false );
			expectParseError( "0xz", false );
			
			// Verify that strict mode errors
			expectParseError( "0xFF0033" );
		}
		
		/**
		 * Non-strict mode allows for NaN as a valid token
		 */
		public function testDecodeNaN():void
		{
			var n:Number = JSON.decode( "NaN", false ) as Number;
			assertTrue( isNaN( n ) );
			
			var o:Object = JSON.decode( "{ \"num\": NaN }", false );
			assertNotNull( o );
			assertTrue( isNaN( o.num ) );
			
			// Verify that strict mode throws an error
			expectParseError( "NaN" );
			expectParseError( "{ \"num\": NaN }" );
		}
		
		public function testDecodeObject():void
		{
			var o:* = JSON.decode( " { \"test\": true, \"test2\": -12356732.12 } " ) as Object;
			assertNotNull( o );
			
			assertEquals( "Expected decoded object.test = true", true, o.test );
			assertEquals( "Expected decoded object.test2 = -12356732.12", -12356732.12, o.test2 );
		}
		
		/**
		 * In non-strict mode, the object can have a trailing comma after
		 * the last member and not throw an error.
		 */
		public function testDecodeObjectWithTrailingComma():void
		{
			var o:Object = JSON.decode( "{\"p1\":true,\"p2\":false,}", false );
			assertNotNull( o );
			assertTrue( o.p1 );
			assertFalse( o.p2 );
			
			o = JSON.decode( "{,}", false );
			assertNotNull( o );
			
			// Verify strict mode throws error with trailing comma
			expectParseError( "{\"p1\":true,\"p2\":false,}" );
			expectParseError( "{,}" );
		}
		
		/**
		 * Leading comma is not supported (yet?  should they be?)
		 */
		public function testDecodeObjectWithLeadingCommaFails():void
		{
			expectParseError( "[,\"p1\":true}", false );
		}
		
		public function testDecodeArray():void
		{
			var o:* = JSON.decode( " [ null, true, false, 100, -100, \"test\", { \"foo\": \"bar\" } ] "  ) as Array;
			assertNull( "Expected decoded array[0] == null", o[0] );
			assertTrue( "Expected decoded array[1] == true", o[1] );
			assertFalse( "Expected decoded array[2] == false", o[2] );
			assertEquals( "Expected decoded array[3] == 100", 100, o[3] );
			assertEquals( "Expected decoded array[4] == -100", -100, o[4] );
			assertEquals( "Expected decoded array[5] == \"test\"", "test", o[5] );
			assertEquals( "Expected decoded array[6].foo == \"bar\"", "bar", o[6].foo );
		}
		
		public function testDecodeArrayWithNewlines():void
		{
			var o:Array = JSON.decode( "\n [ \nnull, \n \r \t \r true \n ] \r \t \r \n" ) as Array;
			
			assertNull( "Expected decoded with newlines array[0] == null", o[0] );
			assertTrue( "Expected decoded with newlines array[1] == true", o[1] );
		}
		
		/**
		 * In non-strict mode, the array can have a trailing comma after
		 * the last element and not throw an error.
		 */
		public function testDecodeArrayWithTrailingComma():void
		{
			var o:Array = JSON.decode( "[0,1,]", false ) as Array;
			assertEquals( 0, o[0] );
			assertEquals( 1, o[1] );
			
			o = JSON.decode( "[,]", false ) as Array;
			assertNotNull( o );
			assertEquals( 0, o.length );
			
			// Verify strict mode throws error with trailing comma
			expectParseError( "[0,1,]" );
			expectParseError( "[,]" );
		}
		
		/**
		 * Leading comma is not supported (yet?  should they be?)
		 */
		public function testDecodeArrayWithLeadingCommaFails():void
		{
			expectParseError( "[,10]", false );
		}
		
		public function testDecodeComments():void
		{
			expectParseError( "/*" );
			expectParseError( "/*/" );
			expectParseError( "//" );
			
			var n:Number = JSON.decode( "// this is a number\n12" );
			assertEquals( 12, n );
			
			n = JSON.decode( "/* \n\n multiine com//ment *///\n14" );
			assertEquals( 14, n )	
		}
		
		public function testDecodeSuccessiveComments():void
		{
			var jsonString:String = "   // test comment"
							+ "\n   // test comment line 2"
							+ "\nfalse";
			var o:* = JSON.decode( jsonString );
			assertEquals( false, o );
		}
		
		public function testDecodeEmptyStringError():void
		{
			expectParseError( "" );
		}
		
		public function testDecodeWhiteSpace():void
		{
			var n:Number;
			var nbsp:String = String.fromCharCode( 160 ); // non-breaking space
			
			n = JSON.decode( " 1 " );
			assertEquals( 1, n );
			
			n = JSON.decode( "\t2\t" );
			assertEquals( 2, n );
			
			n = JSON.decode( "\r3\r" );
			assertEquals( 3, n );
			
			n = JSON.decode( "\n4\n" );
			assertEquals( 4, n );
			
			// Verify combined before/after spacing
			n = JSON.decode( "\t \n\n\r \r\n\t 100 \r\n\t\r\r\r\n  \n" ) as Number
			assertEquals( 100, n );
			
			// In non-strict mode, we should also accept non breaking space
			n = JSON.decode( "\t \n" 
							+ nbsp 
							+ "\n\r \r\n\t 100 \r\n\t\r\r\r\n" 
							+ nbsp 
							+ "  \n", false ) as Number
			assertEquals( 100, n );
			
			// In strict mode, we do NOT accept non breaking space, so expect a parse error
			expectParseError( "\t \n" + nbsp + "\n\r \r\n\t 100 \r\n\t\r\r\r\n" + nbsp + "  \n" );
		}
		
		public function testDecodeWithCharactersLeftInInputString():void
		{
			// strict mode throws errors
			expectParseError( "[ 1 ] true" );
			expectParseError( "0xZ" );
			expectParseError( "true Z" );
			
			// non-strict mode will not throw errors
			var a:Array = JSON.decode( "[ 1 ] true", false ) as Array;
			assertEquals( 1, a[0] );
			
			var n:Number = JSON.decode( "1Z", false ) as Number;
			assertEquals( 1, n );
			
			var b:Boolean = JSON.decode( "true Z", false ) as Boolean;
			assertTrue( b );
		}
		
		public function testEncodeTrue():void
		{
			var o:String = JSON.encode( true );
			assertEquals( "Expected encoded true", "true", o );
		}
		
		public function testEncodeFalse():void
		{
			var o:String = JSON.encode( false );
			assertEquals( "Expected encoded false", "false", o );
		}
		
		public function testEncodeNull():void
		{
			var o:String = JSON.encode( null );
			assertEquals( "Expected encoded null", "null", o );
		}
		
		public function testEncodeString():void
		{
			var o:String = JSON.encode( "this is a \n \"string\"" );
			assertEquals( "Expected encoded string", "\"this is a \\n \\\"string\\\"\"", o );
			
			o = JSON.encode( "myString" );
			assertEquals( "\"myString\"", o );
		}
		
		public function testEncodeArrayEmpty():void
		{
			var o:String = JSON.encode( [] );
			assertEquals( "Expected encoded []", "[]", o );
		}
		
		public function testEncodeArray():void
		{
			var o:String = JSON.encode( [ true, false, -10, null, Number.NEGATIVE_INFINITY ] );
			assertTrue( "Expected encoded array", "[true,false,-10,null,null]", o );
		}
		
		public function testEncodeObjectEmpty():void
		{
			var o:String = JSON.encode( {} );
			assertTrue( "Expected encoded {}", "{}", o );
		}
		
		public function testEncodeObject():void
		{
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
			var customObject:SimpleClass = new SimpleClass();
			customObject.transientVar = "Should not be encoded";
			
			var s:String = JSON.encode( customObject );
			
			assertTrue( "Has length", s.length > 0 );
			// Make sure the transient variable was not encoded
			assertEquals( "Should not find transient var in string", -1,  s.indexOf( "\"transientVar\":\"Should not be encoded\"" ) );

			// Decode the string so we can verify that it has the properties
			var o:Object = JSON.decode( s );

			assertNotNull( o );
			assertNotNull( o.publicVar1 );
			assertNotNull( o.publicVar2 );
			assertNotNull( o.accessor1 );
			assertNotNull( o.accessor2 );
			assertNull( o.transientVar );
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
		
	}
		
}
