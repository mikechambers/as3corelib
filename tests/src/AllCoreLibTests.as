package
{
	import com.adobe.air.crypto.EncryptionKeyGeneratorTest;
	import com.adobe.crypto.HMACMD5Test;
	import com.adobe.crypto.HMACSHA1Test;
	import com.adobe.crypto.MD5Test;
	import com.adobe.crypto.SHA1Test;
	import com.adobe.crypto.SHA224Test;
	import com.adobe.crypto.SHA256Test;
	import com.adobe.crypto.WSSEUsernameTokenTest;
	import com.adobe.images.JPGEncoderTest;
	import com.adobe.images.PNGEncoderTest;
	import com.adobe.net.URITest;
	import com.adobe.serialization.json.JSONTest;
	import com.adobe.utils.ArrayUtilTest;
	import com.adobe.utils.DateUtilTest;
	import com.adobe.utils.DictionaryUtilTest;
	import com.adobe.utils.IntUtilTest;
	import com.adobe.utils.NumberFormatterTest;
	import com.adobe.utils.StringUtilTest;
	import com.adobe.utils.XMLUtilTest;
	import com.adobe.air.filesystem.VolumeMonitorTest;
	import com.adobe.air.filesystem.events.FileMonitorEventTest;
	import com.adobe.air.net.events.ResourceCacheEventTest;
	import com.adobe.protocols.events.ConnectedEventTest;
	import com.adobe.protocols.events.DatabaseEventTest;
	import com.adobe.protocols.events.DefinitionEventTest;
	import com.adobe.protocols.events.DefinitionHeaderEventTest;
	import com.adobe.protocols.events.DictionaryServerEventTest;
	import com.adobe.protocols.events.DisconnectedEventTest;
	import com.adobe.protocols.events.ErrorEventTest;
	import com.adobe.protocols.events.MatchEventTest;
	import com.adobe.protocols.events.MatchStrategiesEventTest;
	import com.adobe.protocols.events.NoMatchEventTest;
	import com.adobe.protocols.util.CompletedResponseEventTest;
	import com.adobe.webapis.events.ServiceEventTest;
	import com.adobe.air.filesystem.FileMonitorTest;
	
	[Suite]
	[RunWith( "org.flexunit.runners.Suite" )]
	public class AllCoreLibTests
	{
		// utils
		public var stringUtilTest:StringUtilTest;
		public var vumberFormatterTest:NumberFormatterTest;
		public var arrayUtilTest:ArrayUtilTest;
		public var dateUtilTest:DateUtilTest;
		public var intUtilTest:IntUtilTest;
		public var xMLUtilTest:XMLUtilTest;
		public var dictionaryUtilTest:DictionaryUtilTest;
		
		// crypto
		public var hMACSHA1Test:HMACSHA1Test;
		public var hMACMD5Test:HMACMD5Test;
		public var mD5Test:MD5Test;
		public var sHA1Test:SHA1Test;
		public var sHA224Test:SHA224Test;
		public var sHA256Test:SHA256Test;
		public var wSSEUsernameTokenTest:WSSEUsernameTokenTest;
		
		// net
		public var uRITest:URITest;
		
		// serialization
		public var jSONTest:JSONTest;		
		
		// images
		public var jPGEncoderTest:JPGEncoderTest;
		public var pNGEncoderTest:PNGEncoderTest;
		
		// protocols.dict
		public var connectedEventTest:ConnectedEventTest;
		public var databaseEventTest:DatabaseEventTest;
		public var definitionEventTest:DefinitionEventTest;
		public var definitionHeaderEventTest:DefinitionHeaderEventTest;
		public var dictionaryServerEventTest:DictionaryServerEventTest;
		public var disconnectedEventTest:DisconnectedEventTest;
		public var errorEventTest:ErrorEventTest;
		public var matchEventTest:MatchEventTest;
		public var matchStrategiesEventTest:MatchStrategiesEventTest;
		public var noMatchEventTest:NoMatchEventTest;
		public var completedResponseEventTest:CompletedResponseEventTest;
		
		// webapis
		public var serviceEventTest:ServiceEventTest;
		
		// air.crypto
		public var encryptionKeyGeneratorTest:EncryptionKeyGeneratorTest;
		
		// air.filesystem
		public var volumeMonitorTest:VolumeMonitorTest;
		public var fileMonitorTest:FileMonitorTest;
		public var fileMonitorEventTest:FileMonitorEventTest;
		
		// air.net
		public var resourceCacheEventTest:ResourceCacheEventTest;
	}
}