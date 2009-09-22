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
	
	import mx.formatters.DateBase;

	public class DateUtilTest extends TestCase
	{	
		
	    public function DateUtilTest(methodName:String = null)
        {
            super(methodName);
            
        }
		
		public function testToW3CDTF():void
		{
			var s:String = "1994-11-05T08:15:30-08:00";
			var d:Date = DateUtil.parseW3CDTF(s);
			assertTrue(s + " == 1994-11-05T16:15:30-00:00",
					   DateUtil.toW3CDTF(d) == "1994-11-05T16:15:30-00:00");
		}
		
		public function testToW3CDTFWithMilliseconds():void
		{
			var s1:String = "1994-11-05T08:15:30.345-00:00";
			
			var d:Date = DateUtil.parseW3CDTF(s1);			
			var s2:String = DateUtil.toW3CDTF(d,false);
			var s3:String = DateUtil.toW3CDTF(d,true);
			
			assertTrue(s1 + " != " + s2, s1 != s2);
			assertTrue(s1 + " == " + s3, s1 == s3);
		}

		public function testParseW3CDTF():void
		{
			//1994-11-05T08:15:30-05:00 corresponds to November 5, 1994, 8:15:30
			// am, US Eastern Standard Time.
			
			var s:String = "1994-11-05T08:15:30.123456-08:00";
			
			var d:Date = DateUtil.parseW3CDTF(s);
			
			assertNotNull("d is null", d);
			assertTrue("d.date == 5",d.date == 5);
			assertTrue("d.month == 10", d.month == 10);  // 10 is November
			assertTrue("d.fullYear == 1994", d.fullYear == 1994);
			// Fixes issue #12 - use UTC so time zone doesn't throw off hours
			assertTrue("d.hoursUTC == 16", d.hoursUTC == 16 );
			assertTrue("d.minutes == 15", d.minutes == 15);
			assertTrue("d.seconds == 30", d.seconds == 30);
			// Can't reliably test time zone offset since the date string's original
			// time zone is converted to the local time zone of the computer running
			// the unit tests.
			//assertTrue("d.timezoneOffset/60 == 8", d.timezoneOffset/60 == 8);
		}
		
		public function testParseW3CDTFWithMilliseconds():void
		{
			//1994-11-05T08:15:30-05:00 corresponds to November 5, 1994, 8:15:30
			// am, US Eastern Standard Time.

			var s:String = "1994-11-05T08:15:30.345-08:00";
			
			var d:Date = DateUtil.parseW3CDTF(s);
			
			assertNotNull("d is null", d);
			assertTrue("d.date == 5",d.date == 5);
			assertTrue("d.month == 10", d.month == 10);  // 10 is November
			assertTrue("d.fullYear == 1994", d.fullYear == 1994);
			// Fixes issue #12 - use UTC so time zone doesn't throw off hours
			assertTrue("d.hoursUTC == 16", d.hoursUTC == 16 );
			assertTrue("d.minutes == 15", d.minutes == 15);
			assertTrue("d.seconds == 30", d.seconds == 30);
			assertTrue("d.milliseconds == 345", d.milliseconds == 345);
			// Can't reliably test time zone offset since the date string's original
			// time zone is converted to the local time zone of the computer running
			// the unit tests.
			//assertTrue("d.timezoneOffset/60 == 8", d.timezoneOffset/60 == 8);

			// Now test without padding (date, month, offset)
			var s2:String = "1994-9-5T8:15:30.345-8:00";
			
			var d2:Date = DateUtil.parseW3CDTF(s2);
			
			assertNotNull("d2 is null", d2);
			assertTrue("d2.date == 5",d2.date == 5);
			assertTrue("d2.month == 10", d2.month == 8);  // 8 is september
			assertTrue("d2.fullYear == 1994", d2.fullYear == 1994);
			// Fixes issue #12 - use UTC so time zone doesn't throw off hours
			assertTrue("d2.hoursUTC == 16", d2.hoursUTC == 16 );
			assertTrue("d2.minutes == 15", d2.minutes == 15);
			assertTrue("d2.seconds == 30", d2.seconds == 30);
			assertTrue("d2.milliseconds == 345", d2.milliseconds == 345);

		}
		
		public function testW3CDTF():void
		{
			var d1:Date = new Date();
			
			d1.setMilliseconds(0);
			
			var s:String = DateUtil.toW3CDTF(d1);
			
			var d2:Date = DateUtil.parseW3CDTF(s);
			
			assertTrue("DateUtil.compareDates(d1, d2) == 0",
											DateUtil.compareDates(d1, d2) == 0);
		}		
		
		public function testRFC822():void
		{
			var d1:Date = new Date();
			
			d1.setMilliseconds(0);
			
			var s:String = DateUtil.toRFC822(d1);
			
			var d2:Date = DateUtil.parseRFC822(s);
			
			assertTrue("DateUtil.compareDates(d1, d2) == 0",
											DateUtil.compareDates(d1, d2) == 0);
		}
		
		public function testToRFC822():void
		{
			// "Mon, 05 Dec 2005 14:55:43 -0800";
			
			var d:Date = new Date(Date.UTC(2005,0,1,1,1,1,0));
			
			assertTrue("DateUtil.toRFC822(d) == \"Sat, 01 Jan 2005 01:01:01 GMT\"",
					DateUtil.toRFC822(d) == "Sat, 01 Jan 2005 01:01:01 GMT");
		}
		
		public function testGetAMPM():void
		{
			var d:Date = new Date(2005,1,1);
			
			d.hours = 7;
			assertTrue("DateUtil.getAMPM(d) == \"AM\"",
												DateUtil.getAMPM(d) == "AM");
												
			d.hours = 23;
			assertTrue("DateUtil.getAMPM(d) == \"PM\"",
												DateUtil.getAMPM(d) == "PM");
												
			d.hours = 12;
			assertTrue("DateUtil.getAMPM(d) == \"PM\"",
												DateUtil.getAMPM(d) == "PM");
												
			d.hours = 11;
			assertTrue("DateUtil.getAMPM(d) == \"AM\"",
												DateUtil.getAMPM(d) == "AM");
																																			
			d.hours = 0;
			assertTrue("DateUtil.getAMPM(d) == \"AM\"",
												DateUtil.getAMPM(d) == "AM");		
												
			d.hours = 13;
			assertTrue("DateUtil.getAMPM(d) == \"PM\"",
												DateUtil.getAMPM(d) == "PM");
		}
		
		public function testGetShortHours():void
		{
			var d:Date = new Date(2005,1,1);
			
			d.hours = 7;
			assertTrue("DateUtil.getShortHour(d) == 7",
												DateUtil.getShortHour(d) == 7);
												
			d.hours = 23;
			assertTrue("DateUtil.getShortHour(d) == 11",
												DateUtil.getShortHour(d) == 11);
												
			d.hours = 12;
			assertTrue("DateUtil.getShortHour(d) == 12",
												DateUtil.getShortHour(d) == 12);
																																			
			d.hours = 0;
			assertTrue("DateUtil.getShortHour(d) == 12",
												DateUtil.getShortHour(d) == 12);		
												
			d.hours = 13;
			assertTrue("DateUtil.getShortHour(d) == 1",
												DateUtil.getShortHour(d) == 1);																				
		}
		
		public function testParseRFC822():void
		{
			var s:String = "Mon, 05 Dec 2005 14:55:43 -0800";
			
			var d:Date = DateUtil.parseRFC822(s);
			
			assertNotNull("d is null", d);
			assertTrue("d.date == 5",d.date == 5);
			assertTrue("d.month == 11", d.month == 11);
			assertTrue("d.fullYear == 2005", d.fullYear == 2005);
			// Fixes issue #12 - use UTC so time zone doesn't throw off hours
			assertTrue("d.hoursUTC == 22", d.hoursUTC == 22 );
			assertTrue("d.minutes == 55", d.minutes == 55);
			assertTrue("d.seconds == 43", d.seconds == 43);
			
			var exception:Boolean = false;
			try
			{
				DateUtil.parseRFC822("foo");
			}
			catch(e:Error)
			{
				exception = true;
			}
			
			if(!exception)
			{
				assertTrue("DateUtil.parseRFC822(\"foo\") did not throw an exception.", false);
			}

			// Now try a string without padding (date and hour)
			var s2:String = "Mon, 5 Dec 2005 9:55:43 -0800";
			
			var d2:Date = DateUtil.parseRFC822(s2);
			
			assertNotNull("d is null", d2);
			assertTrue("d2.date == 5",d2.date == 5);
			assertTrue("d2.month == 11", d2.month == 11);
			assertTrue("d2.fullYear == 2005", d2.fullYear == 2005);
			// Fixes issue #12 - use UTC so time zone doesn't throw off hours
			assertTrue("d2.hoursUTC == 22", d2.hoursUTC == 17);
			assertTrue("d2.minutes == 55", d2.minutes == 55);
			assertTrue("d2.seconds == 43", d2.seconds == 43);

			//var s3:String = "Wed, 2 Jan 2007 04:00:00 PST";
			//var d3:Date = DateUtil.parseRFC822(s3);
			//trace(d3);

		}
		
		
		public function testCompareDates():void
		{
			var d1:Date = new Date(2005,0,1,1,1,1,1);
			var d2:Date = new Date(2006,0,1,1,1,1,1);
			var d4:Date = new Date(2005,0,1,1,1,1,1);
			
			assertTrue("DateUtil.compareDates(d1, d2) == 1",
										DateUtil.compareDates(d1, d2) == 1);
										
			assertTrue("DateUtil.compareDates(d2, d1) == -1",
										DateUtil.compareDates(d2, d1) == -1);
										
			assertTrue("DateUtil.compareDates(d1, d1) == 0",
										DateUtil.compareDates(d1, d1) == 0);
										
			assertTrue("DateUtil.compareDates(d1, d4) == 0",
										DateUtil.compareDates(d1, d4) == 0);
		}
		
		public function testGetShortYear():void
		{
			var d:Date = new Date(2005);
			
			d.fullYear = 2005;
			assertTrue("DateUtil.getShortYear(d) == \"05\"",
								DateUtil.getShortYear(d) == "05");
								
			d.fullYear = 2000;
			assertTrue("DateUtil.getShortYear(d) == \"00\"",
								DateUtil.getShortYear(d) == "00");
								
			d.fullYear = 1900;
			assertTrue("DateUtil.getShortYear(d) == \"00\"",
								DateUtil.getShortYear(d) == "00");
								
			d.fullYear = 21501;
			assertTrue("DateUtil.getShortYear(d) == \"01\"",
								DateUtil.getShortYear(d) == "01");
								
			d.fullYear = 10;
			assertTrue("DateUtil.getShortYear(d) == \"10\"",
								DateUtil.getShortYear(d) == "10");
								
			d.fullYear = 7;
			assertTrue("DateUtil.getShortYear(d) == \"7\"",
								DateUtil.getShortYear(d) == "7");
		}
		
		public function testGetFullDayIndex():void
		{
			
			var len:int = DateBase.dayNamesLong.length;
			
			for(var i:int = 0; i < len; i++)
			{
				assertTrue("DateUtil.getFullDayIndex(DateBase.dayNamesLong["+i+"]) == i",
								DateUtil.getFullDayIndex(DateBase.dayNamesLong[i]) == i);
			}
		}		
		
		public function testGetFullMonthIndex():void
		{
			//var len:int = FULL_MONTH.length;
			var len:int = DateBase.monthNamesLong.length;
			
			for(var i:int = 0; i < len; i++)
			{
				assertTrue("DateUtil.getFullMonthIndex(DateBase.monthNamesLong["+i+"]) == i",
								DateUtil.getFullMonthIndex(DateBase.monthNamesLong[i]) == i);
			}
		}
		
		public function testGetFullDayName():void
		{
			var d:Date;
			
			//var len:uint = FULL_DAY.length;
			var len:int = DateBase.dayNamesLong.length;
			
			for(var i:uint = 0; i < len; i++)
			{
				//12-04-2005 is a sunday
				d = new Date(2005,11, i + 4);
				
				assertTrue("DateUtil.getFullDayName(d) == DateBase.dayNamesLong["+i+"]",
								DateUtil.getFullDayName(d) == DateBase.dayNamesLong[i]);
			}
		}		
		
		public function testGetFullMonthName():void
		{
			var d:Date;
			
			//var len:uint = FULL_MONTH.length;
			var len:int = DateBase.monthNamesLong.length;
			
			for(var i:uint = 0; i < len; i++)
			{
				d = new Date(2005,i);
				
				assertTrue("DateUtil.getFullMonthName(d) == DateBase.monthNamesLong["+i+"]",
								DateUtil.getFullMonthName(d) == DateBase.monthNamesLong[i]);
			}
		}		
		
		public function testGetShortDayIndex():void
		{
			//var len:int = SHORT_DAY.length;
			var len:int = DateBase.dayNamesShort.length;
			
			for(var i:int = 0; i < len; i++)
			{
				assertTrue("DateUtil.getShortDayIndex(DateBase.dayNamesShort["+i+"]) == i",
								DateUtil.getShortDayIndex(DateBase.dayNamesShort[i]) == i);
			}
		}		
		
		public function testGetShortMonthIndex():void
		{
			//var len:int = SHORT_MONTH.length;
			var len:int = DateBase.monthNamesShort.length;
			
			for(var i:int = 0; i < len; i++)
			{
				assertTrue("DateUtil.getShortMonthIndex(DateBase.monthNamesShort["+i+"]) == i",
								DateUtil.getShortMonthIndex(DateBase.monthNamesShort[i]) == i);
			}
		}
		
		public function testGetShortDayName():void
		{
			var d:Date;
			
			//var len:uint = SHORT_DAY.length;
			var len:int = DateBase.dayNamesShort.length;
			
			for(var i:uint = 0; i < len; i++)
			{
				//12-04-2005 is a sunday
				d = new Date(2005,11, i + 4);
				
				assertTrue("DateUtil.getShortDayName(d) == DateBase.dayNamesShort["+i+"]",
								DateUtil.getShortDayName(d) == DateBase.dayNamesShort[i]);
			}
		}		
		
		public function testGetShortMonthName():void
		{
			var d:Date;
			
			//var len:uint = SHORT_MONTH.length;
			var len:int = DateBase.monthNamesShort.length;
			
			for(var i:uint = 0; i < len; i++)
			{
				d = new Date(2005,i);
				
				assertTrue("DateUtil.getShortMonthName(d) == DateBase.monthNamesShort["+i+"]",
								DateUtil.getShortMonthName(d) == DateBase.monthNamesShort[i]);
			}
		}
	}
}