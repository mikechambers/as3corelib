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

package com.adobe.utils
{

	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import com.adobe.utils.IntUtil;
	
	public class IntUtilTest extends TestCase {
		
	    public function IntUtilTest( methodName:String = null) {
			super( methodName );
        }
	

		
		public function testRol():void {
			assertTrue( "IntUtil.rol( 0x00000001, 1 )", IntUtil.rol( 0x00000001, 1 ) == 0x00000002 );
			assertTrue( "IntUtil.rol( 0x00000001, 2 )", IntUtil.rol( 0x00000001, 2 ) == 0x00000004 );
			assertTrue( "IntUtil.rol( 0x00000001, 4 )", IntUtil.rol( 0x00000001, 4 ) == 0x00000010 );
			assertTrue( "IntUtil.rol( 0x00000001, 8 )", IntUtil.rol( 0x00000001, 8 ) == 0x00000100 );
			assertTrue( "IntUtil.rol( 0x00000001, 12 )", IntUtil.rol( 0x00000001, 12 ) == 0x00001000 );
			assertTrue( "IntUtil.rol( 0x00000001, 16 )", IntUtil.rol( 0x00000001, 16 ) == 0x00010000 );
			assertTrue( "IntUtil.rol( 0x00000001, 20 )", IntUtil.rol( 0x00000001, 20 ) == 0x00100000 );
			assertTrue( "IntUtil.rol( 0x00000001, 24 )", IntUtil.rol( 0x00000001, 24 ) == 0x01000000 );
			assertTrue( "IntUtil.rol( 0x00000001, 28 )", IntUtil.rol( 0x00000001, 28 ) == 0x10000000 );
			assertTrue( "IntUtil.rol( 0x00000001, 31 )", uint( IntUtil.rol( 0x00000001, 31 ) ) == 0x80000000 );
			assertTrue( "IntUtil.rol( 0x00000001, 32 )", IntUtil.rol( 0x00000001, 32 ) == 0x00000001 );
			
			assertTrue( "IntUtil.rol( 0x80000000, 1 )", IntUtil.rol( int( 0x80000000 ), 1 ) == 0x00000001 );
		}
		
		public function testToHex():void {
			assertTrue( "Little Endian", IntUtil.toHex( 0x12345678 ) == "78563412" );
			assertTrue( "Big Endian", IntUtil.toHex( 0x12345678, true ) == "12345678" );
			
			assertTrue( "Little Endian Negative", IntUtil.toHex( int( 0x89ABCDEF ) ) == "efcdab89" );
			assertTrue( "Big Endian Negative", IntUtil.toHex( int( 0x89ABCDEF ), true ) == "89abcdef" );
		}
	}
}