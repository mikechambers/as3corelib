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
	FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  ALSO, THERE IS NO WARRANTY OF 
	NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT.  IN NO EVENT SHALL MACROMEDIA
	OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
	EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
	PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
	OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
	WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
	OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
	ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package com.adobe.utils
{

	/**
	* 	Class that contains static utility methods for formatting Numbers
	* 
	* 	@langversion ActionScript 3.0
	*	@playerversion Flash 9.0
	*	@tiptext
	*
	*	@see #mx.formatters.NumberFormatter
	*/		
	public class NumberFormatter
	{
	
		/**
		*	Formats a number to include a leading zero if it is a single digit
		*	between -1 and 10. 	
		* 
		* 	@param n The number that will be formatted
		*
		*	@return A string with single digits between -1 and 10 padded with a 
		*	leading zero.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/		
		public static function addLeadingZero(n:Number):String
		{
			var out:String = String(n);
			
			if(n < 10 && n > -1)
			{
				out = "0" + out;
			}
			
			return out;
		}
		
		/**
		*	Formats a number to include a specified thousands separator 
		*
		* 	@param p_num The number that will be formatted
		*
		*	@param p_separator The character to use as a thousands separator
		*
		*	@return A string with the specified thousands separator 
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function addSeparator(p_num:Number, p_separator:String):String
		{
			var out:String = String(p_num);
			if (Math.abs(p_num) < 1000) return out;	// Nothing to add a separator between so exit
			
			var numArray:Array = String(p_num).split(".");
			var intVal:String = numArray[0];
			var decVal:String = (numArray.length > 1) ? "." + numArray[1] : "";
						
			var pattern:RegExp = /\d{1,3}(?=(\d{3})+(?!\d))/g;
			
			var patObj:String = "$&"+ p_separator;
			
			while (pattern.test(intVal)) {
				intVal = intVal.replace(pattern, patObj);
			}
			
			out = intVal + decVal;
			
			return out;
		}
		
		/**
		*	Formats a number to include a specified decimal point character 
		*
		* 	@param p_num The number that will be formatted
		*
		*	@param p_decimal The character to use as a decimal point
		*
		*	@return A string with the specified decimal point character
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function formatDecimal(p_num:Number, p_decimal:String="."):String
		{
			var out:String = String(p_num);
			
			var pattern:RegExp = /\./;
			var patObj:String = p_decimal;
			
			while (pattern.test(out)) {
				out = out.replace(pattern, patObj);
			}
			
			return out;
		}
		
		/**
		*	Formats a number to include a specified thousands separator and decimal point character,  
		*	as well, it rounds the number to a specified number of decimal places 
		*
		* 	@param p_num The number that will be formatted
		*
		*	@param p_separator The character to use as a thousands separator
		*
		*	@param p_decimalPlaces The number of decimal places
		*
		*	@param p_decimal The character to use as a decimal point
		*
		*	@return A string with the specified decimal point, decimal places and thousands separator 
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function format(p_num:Number, p_separator:String="", p_decimalPlaces:Number=0, p_decimal:String=".") 
		{
			var out:String = "";
			var numArray:Array = String(p_num).split(".");
			var intVal:String = numArray[0];
			var decVal:String = numArray[1];
			var rounded:int;
			var isNeg:Boolean = false;
			
			if (p_num < 0) 
			{
				isNeg = true;
				p_num = Math.abs(p_num);
			}
			
			if (p_decimalPlaces > -1)
			{
				if (p_num < 0.1)
				{
					out = (isNeg==true) ? "-0" + p_decimal : "0" + p_decimal;
										
					rounded = Math.pow(10, p_decimalPlaces);
					p_num = Math.round(p_num * rounded);
					
					var decCount:int = p_decimalPlaces;
					var strLen:int = String(p_num).length;
					while (decCount > strLen) {
						out += "0";
						decCount--;
					}
					out += String(p_num);
					
					return out;
				}
				
				rounded = Math.pow(10, p_decimalPlaces);
				p_num = Math.round(p_num * rounded);
				
				if (p_decimalPlaces == 0)
				{
					intVal = String(p_num);
				}
				
				decVal = (p_decimalPlaces > 0) ? p_decimal + String(p_num).substr(String(p_num).length - p_decimalPlaces) : "";
				
			} else {
				decVal = p_decimal + decVal;
			}
			
			var pattern:RegExp = /\d{1,3}(?=(\d{3})+(?!\d))/g;
			
			var patObj:String = "$&"+ p_separator;
			
			while (pattern.test(intVal))
			{
				intVal = intVal.replace(pattern, patObj);
			}
			
			out = intVal + decVal;
			
			return out;
		}		
	
	}
}