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

package com.adobe.net
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import com.adobe.net.URI;
	import com.adobe.net.IURIResolver;
	
	public class URITest extends TestCase implements IURIResolver
	{
	    public function URITest( methodName:String=null )
	    {
			super( methodName );
        }

		/**
		 * 
		 */
		public function testParsing() : void
		{
			var mt:String = "";
			
			parseAndTest("http://test.com", "http", mt, mt, "test.com",
				mt, mt,	mt, mt, mt);
		
			parseAndTest("http://test.com/", "http", mt, mt, "test.com",
				mt, "/", mt, mt, mt);
		
			parseAndTest("http://test.com:80", "http", mt, mt, "test.com",
				"80", mt, mt, mt, mt);
		
			parseAndTest("http://www.test.com/my/path/file.html",
				"http",	mt, mt, "www.test.com", mt, "/my/path/file.html", mt, mt, mt);
		
			parseAndTest("http://www.test.com/?query=yes&name=bob",
				"http",	mt, mt, "www.test.com", mt, "/", "query=yes&name=bob", mt, mt);
		
			parseAndTest("http://www.test.com/index.html#foo",
				"http",	mt, mt, "www.test.com", mt, "/index.html", mt, "foo", mt);
		
			parseAndTest("http://www.test.com/#foo", "http",
				mt, mt, "www.test.com", mt, "/", mt, "foo", mt);
		
			parseAndTest("http://www.test.com/?test=1&copy=yes",
				"http",	mt, mt, "www.test.com", mt, "/", "test=1&copy=yes", mt, mt);
				
			// Test everything
			parseAndTest("https://bobarino:password37$%25@test.com:9100/path/to/file.html?param1=foo&param2=bar#anchor",
				"https", "bobarino", "password37$%", "test.com", "9100",
				"/path/to/file.html", "param1=foo&param2=bar", "anchor", mt);
				
			// Test everything with escaped characters and characters that
			// may be considered borderline.
			parseAndTest("https://bobarino%3A:pass%3Aword37$@test.com:9100/pa%3Fth/to/fi:le.html?param1=:&param2=?#anchor%23",
				"https", "bobarino:", "pass:word37$", "test.com", "9100",
				"/pa?th/to/fi:le.html", "param1=:&param2=?", "anchor#", mt);
				
			// Test the common case where people embed another URI in the
			// query part of the base URI.  This is often used when
			// communicating through a proxy.  We don't want to break or
			// escape more characters than needed.
			parseAndTest("http://jim:%25password%25@someproxy.com:8877/proxy.php?url=http://othersite.com/path/to/file.html&proxyparam=doit#proxyanchor",
				"http", "jim", "%password%", "someproxy.com", "8877",
				"/proxy.php", "url=http://othersite.com/path/to/file.html&proxyparam=doit",
				"proxyanchor", mt);
		}
		
		public function testRelativeParsing() : void
		{
			var mt:String = "";
			
			// Yes, "www.test.com" is a relative URI.  To us, it seems natural that
			// it should be the host name, but without a scheme, its relative.
			// For example, "www.tar.gz" is a UNIX tar/gzip file and is relative.
			// Whats the difference between "www.test.com" and "www.tar.gz"?  If it
			// has no scheme, it is relative.  Period.  URI::UnknownToURI tries to
			// be smart, but the problem is that it could make a wrong guess in
			// certain situations.
			parseAndTest("www.test.com", mt, mt, mt, mt, mt,
				"www.test.com", mt, mt, mt);
		
			// Just a fragment (anchor)
			parseAndTest("#foo", mt, mt, mt, mt, mt, mt, mt,
				"foo", mt);
		
			// queries can have ';' as an alternative separator to '&'
			parseAndTest("?query=yes;this=that#foo",
				mt, mt, mt, mt, mt, mt, "query=yes;this=that", "foo", mt);
		
			parseAndTest("/images?blah:somequery",
				mt, mt, mt, mt, mt,	"/images", "blah:somequery", mt, mt);
				
			parseAndTest("/images?blah:somequery#anchor",
				mt, mt, mt, mt, mt,	"/images", "blah:somequery", "anchor", mt);
		}
		
		
		public function testUnknownParsing() : void
		{
			var mt:String = "";
			
			// Something missing the scheme
			parseUnknownAndTest(
				"www.somesite.com", // input
				"http://www.somesite.com", // expected
				"http",	mt, mt, "www.somesite.com", mt, mt, mt ,mt ,mt);

			// URI missing a scheme, but has slashes
			parseUnknownAndTest(
				"//server/path/to/file.html", // input
				"http://server/path/to/file.html", // expected
				"http", mt, mt, "server", mt, "/path/to/file.html", mt, mt, mt);
								
			// Missing scheme with everything else
			parseUnknownAndTest(
				"://user:pass@server:8080/path/to/file.html?param1=value1#anchor",
				"http://user:pass@server:8080/path/to/file.html?param1=value1#anchor",
				"http", "user", "pass", "server", "8080",
				"/path/to/file.html", "param1=value1", "anchor", mt);
		
			// Make sure the unknown handles the case of a real and valid URI
			parseUnknownAndTest(
				"http://user:pass@www.somesite.com:200/path/to/file.html?query#foo",
				"http://user:pass@www.somesite.com:200/path/to/file.html?query#foo",
				"http",	"user", "pass", "www.somesite.com", "200",
				"/path/to/file.html", "query", "foo", mt);
		
			// A valid non-hierarchical URI
			parseUnknownAndTest("mailto:bob@smith.com",
				"mailto:bob@smith.com",
				"mailto", mt, mt, mt, mt, mt, mt, mt, "bob@smith.com");
		
			// malformed URI.  Some people like to type backslashes
			// instead of forward slashes.
			parseUnknownAndTest(
				"http:\\\\somesite.com\\path\\to\\file.html",
				"http://somesite.com/path/to/file.html",
				"http", mt, mt, "somesite.com", mt, "/path/to/file.html", mt, mt, mt);
		
			// A valid relative URI.  Note that UnknownToURI will only detect
			// relative paths that start with ".", or "..".  Otherwise, it will
			// guess that the path is just something missing the scheme.
			parseUnknownAndTest(
				"../../images/logo.gif",
				"../../images/logo.gif",
				mt, mt, mt, mt, mt, "../../images/logo.gif", mt, mt, mt);
		}
		
		public function testNonHierarchical() : void
		{
			var mt:String = "";
			
			parseAndTest("mailto:bob@smith.com",
				"mailto", mt, mt, mt, mt, mt, mt, mt, "bob@smith.com");
		
			parseAndTest("about:blank?foo=bar#baz",
				"about", mt, mt, mt, mt, mt, "foo=bar", "baz", "blank");
		}
		
		/**
		 * This tests the getRelation() method of URI.  Given two URI's,
		 * determine the relation of the two relative to the object that
		 * getRelation() is called on.
		 */
		public function testEquivalence() : void
		{
			// The same
			parseAndCompare("http://a/b/c/d", "http://a/b/c/d", URI.EQUAL, URI.EQUAL);
			
			// Parent/child
			parseAndCompare("http://a/b/c/d/", "http://a/b/c/d/e/f/", URI.PARENT, URI.CHILD);
			
			// Not related.  They are in different branches.
			parseAndCompare("http://a/b/c/g", "http://a/b/c/d/e/f/", URI.NOT_RELATED, URI.NOT_RELATED);
			
			// special case
			parseAndCompare("http://somesite.com/", "http://somesite.com", URI.EQUAL, URI.EQUAL);
			
			// non-hierarchical
			parseAndCompare("mailto:bob@smith.com", "mailto:bob@smith.com", URI.EQUAL, URI.EQUAL);
			parseAndCompare("mailto:bob@smith.com", "mailto:sue@company.com", URI.NOT_RELATED, URI.NOT_RELATED);
			parseAndCompare("mailto:bob@smith.com", "http://test.com", URI.NOT_RELATED, URI.NOT_RELATED);
			
			// different schemes
			parseAndCompare("http://test.com", "https://test.com", URI.NOT_RELATED, URI.NOT_RELATED);
			
			// test default port
			parseAndCompare("http://test.com:80", "http://test.com", URI.EQUAL, URI.EQUAL);
			parseAndCompare("http://test.com:81", "http://test.com", URI.NOT_RELATED, URI.NOT_RELATED);
			
			// test dynamic resolution.
			URI.resolver = this;
			parseAndCompare("http://test.com", "http://test.org", URI.EQUAL, URI.EQUAL);
			
			// GetRelation() does not take into account query and fragment
			// parts.  This is probably an edge case that we do not handle
			// at this time.  If we ever modify GetRelation() to handle
			// that case, we need to add test cases here.
		}
		
		public function testEscaping() : void
		{
			var uri:URI = new URI();
		
			uri.setParts("http", "test.com", "80", "/my path/with %weird/chars",
				"search=~&name={bob}", "five%");
		
			assertEquals("Characters not properly escaped.",
				"http://test.com:80/my%20path/with%20%25weird/chars?search=~&name={bob}#five%25",
				uri.toString());
		
			var test:String = "http://test.com/  funky/{path}";
		
			uri = new URI(test);
			uri.forceEscape();
		
			assertEquals("Characters not properly escaped.",
				"http://test.com/%20%20funky/{path}", uri.toString());
		
			// Make sure the display version does not include escaped chars.
			assertEquals("toDisplayString() failed.", test, uri.toDisplayString());
		}
		
		public function parseAndCompare(str1:String, str2:String, rel1:int, rel2:int) : void
		{
			var uri1:URI, uri2:URI;
			var result1:int, result2:int;
		
			uri1 = new URI(str1);
			uri2 = new URI(str2);
		
			result1 = uri1.getRelation(uri2);
			result2 = uri2.getRelation(uri1); // swapped
			
			assertTrue("Relation check failed.", result1 == rel1);
			assertTrue("Relation check failed.", result2 == rel2); 
			
			// Make sure nothing got modified.
			assertEquals("getRelation() modified uri1.", str1, uri1.toString());
			assertEquals("getRelation() modified uri2.", str2, uri2.toString());
		}
		
		
		protected function parseUnknownAndTest(
			inURI:String, expectedURI:String, scheme:String,
			username:String, password:String, authority:String,
			port:String, path:String, query:String, fragment:String,
			nonHierarchical:String) : void
		{
			var uri:URI = new URI();
			
			uri.unknownToURI(inURI);
			
			// We expect all cases to produce a valid URI
			assertTrue("URI is invalid.", uri.isValid());
			
			// Make sure we get out what we expect
			assertEquals("URI.toString() should output what we input.", expectedURI, uri.toString());
			
			if (uri.isHierarchical())
			{
				assertEquals("URI.scheme should be the same.", scheme, uri.scheme);
				assertEquals("URI.username should be the same.", username, uri.username);
				assertEquals("URI.password should be the same.", password, uri.password);
				assertEquals("URI.authority should be the same.", authority, uri.authority);
				assertEquals("URI.port should be the same.", port, uri.port);
				assertEquals("URI.path should be the same.", path, uri.path);
				assertEquals("URI.query should be the same.", query, uri.query);
				assertEquals("URI.fragment should be the same.", fragment, uri.fragment);	
			}
			else
			{
				assertEquals("URI.scheme should be the same.", scheme, uri.scheme);
				assertEquals("URI.nonHierarchical should be the same.", nonHierarchical, uri.nonHierarchical);
				assertEquals("URI.query should be the same.", query, uri.query);
				assertEquals("URI.fragment should be the same.", fragment, uri.fragment);
			}
		}
		
		/**
		 * This function takes a URI in string form and a set
		 * of expected results for each of the URI parts.  This
		 * function loads the 'inURI' string into a URI object
		 * and then compares the resulting object parts to the
		 * given expected result strings.
		 */
		protected function parseAndTest(inURI:String,
			scheme:String, username:String, password:String,
			authority:String, port:String,
			path:String, query:String, fragment:String,
			nonHierarchical:String) : void
		{
			var result:Boolean = true;
		
			// Construct our test URI
			var uri:URI = new URI(inURI);
		
			// Make sure we get out what we put in.
			assertEquals("URI.toString() should output what we input.", inURI, uri.toString());
		
			if (uri.isHierarchical())
			{
				assertEquals("URI.scheme should be the same.", scheme, uri.scheme);
				assertEquals("URI.username should be the same.", username, uri.username);
				assertEquals("URI.password should be the same.", password, uri.password);
				assertEquals("URI.authority should be the same.", authority, uri.authority);
				assertEquals("URI.port should be the same.", port, uri.port);
				assertEquals("URI.path should be the same.", path, uri.path);
				assertEquals("URI.query should be the same.", query, uri.query);
				assertEquals("URI.fragment should be the same.", fragment, uri.fragment);
			}
			else
			{
				assertEquals("URI.scheme should be the same.", scheme, uri.scheme);
				assertEquals("URI.nonHierarchical should be the same.", nonHierarchical, uri.nonHierarchical);
				assertEquals("URI.query should be the same.", query, uri.query);
				assertEquals("URI.fragment should be the same.", fragment, uri.fragment);
			}
			
			// Now perform the test the other way.  Set all the members
			// and compare the toString() to the given URI.
			if (nonHierarchical.length > 0)
			{
				uri = new URI();
				
				uri.scheme = scheme;
				uri.nonHierarchical = nonHierarchical;
				uri.query = query;
				uri.fragment = fragment;
				
				assertEquals("URI.toString() should be the same.", uri.toString(), inURI);
			}
			else
			{
				uri = new URI();
				
				uri.scheme = scheme;
				uri.username = username;
				uri.password = password;
				uri.authority = authority;
				uri.port = port;
				uri.path = path;
				uri.query = query;
				uri.fragment = fragment;
				
				assertEquals("URI.toString() should be the same.", inURI, uri.toString());
			}
		}
		
		/**
		 * This test case runs through a large number of cases that exercises
		 * the chdir(), makeAbsolute(), and makeRelative() functions.
		 */
		public function testAbsRelChDir() : void
		{
			// ***
			// These tests are taken directly from the URI RFC.
			// ***
		
			// Note that the ';' is part of the file name.  It's not
			// some special character.
			var base:String = "http://a/b/c/d;p?q";
		
			// A full URI completely replaces the old one.  The RFC used "g:h" for
			// their example, but we use "gj:hk" because we assume that a single
			// character scheme is most likely a "C:\" style path.  The test is
			// the same.
			doTestChDir(base, "gj:hk",	"gj:hk", true);
		
			doTestChDir(base, "g",		"http://a/b/c/g");
			doTestChDir(base, "./g",		"http://a/b/c/g");
			doTestChDir(base, "g/",		"http://a/b/c/g/");
			doTestChDir(base, "/g",		"http://a/g");
		
			// The "//" is the delimiter for an authority.
			// This kind of "path" replaces everything after
			// the scheme.
			doTestChDir(base, "//g",		"http://g", true);
			
			doTestChDir(base, "?y",		"http://a/b/c/?y");
			doTestChDir(base, "g?y",		"http://a/b/c/g?y");
			doTestChDir(base, "#s",		"http://a/b/c/d;p?q#s");
			doTestChDir(base, "g#s",		"http://a/b/c/g#s");
			doTestChDir(base, "g?y#s",	"http://a/b/c/g?y#s");
			doTestChDir(base, ";x",		"http://a/b/c/;x");
			doTestChDir(base, "g;x",		"http://a/b/c/g;x");
			doTestChDir(base, "g;x?y#s",	"http://a/b/c/g;x?y#s");
			doTestChDir(base, ".",		"http://a/b/c/");
			doTestChDir(base, "./",		"http://a/b/c/");
			doTestChDir(base, "..",		"http://a/b/");
			doTestChDir(base, "../",		"http://a/b/");
			doTestChDir(base, "../g",	"http://a/b/g");
			doTestChDir(base, "../..",	"http://a/");
			doTestChDir(base, "../../",	"http://a/");
			doTestChDir(base, "../../g",	"http://a/g");
		
			// *** Abnormal cases ***
			// These are cases where the input goes beyond the scope of the URI.
			// We need to handle these gracefully if possible.
			doTestChDir(base, "../../../g",	"http://a/g");
			doTestChDir(base, "../../../../g",	"http://a/g");
		
			// These are absolute.  Notice that the "." and ".." are not
			// collapsed here.  We won't do Abs/Rel tests on them (the true)
			// because they just too abnormal.  Just make sure ChDir works.
			doTestChDir(base, "/./g",	"http://a/./g", true);
			doTestChDir(base, "/../g",	"http://a/../g", true);
		
			doTestChDir(base, "g.",		"http://a/b/c/g.");
			doTestChDir(base, ".g",		"http://a/b/c/.g");
			doTestChDir(base, "g..",		"http://a/b/c/g..");
			doTestChDir(base, "..g",		"http://a/b/c/..g");
			doTestChDir(base, "./../g",	"http://a/b/g");
			doTestChDir(base, "./g/.",	"http://a/b/c/g/");
			doTestChDir(base, "g/./h",	"http://a/b/c/g/h");
			doTestChDir(base, "g/../h",	"http://a/b/c/h");
			doTestChDir(base, "g;x=1/./y",	"http://a/b/c/g;x=1/y");
			doTestChDir(base, "g;x=1/../y",	"http://a/b/c/y");
		
			// All client applications remove the query component from the base URI
			// before resolving relative URI.  However, some applications fail to
			// separate the reference's query and/or fragment components from a
			// relative path before merging it with the base path.  This error is
			// rarely noticed, since typical usage of a fragment never includes the
			// hierarchy ("/") character, and the query component is not normally
			// used within relative references.
			doTestChDir(base, "g?y/./x",	"http://a/b/c/g?y/./x");
			doTestChDir(base, "g?y/../x","http://a/b/c/g?y/../x");
			doTestChDir(base, "g#s/./x",	"http://a/b/c/g#s/./x");
			doTestChDir(base, "g#s/../x","http://a/b/c/g#s/../x");
		
			// Custom checks dealing with relative URI's as the base.
			base = "../../a/b/c";
		
			doTestChDir(base, "d",		"../../a/b/d", true);
			doTestChDir(base, "../d",		"../../a/d", true);
			doTestChDir(base, "../../d",  "../../d", true);
			doTestChDir(base, "../../../d",	"../../../d", true);
		
			// One last crazy relative path
			base = "../../../a";
			doTestChDir(base, "../../../../d", "../../../../../../../d", true);
		
		
			// Lastly, a specific check for known edge case
			base = "http://a/b/c/";
			var uri:URI = new URI(base);
			var baseURI:URI = new URI(base);
		
			// Making a URI relative to itself
			uri.makeRelativeURI(baseURI);
			assertEquals("makeRelativeURI() failed for identity case.", "./", uri.toString());
		}
		
		
		/**
		 * The main guts of testAbsRelChDir().  This takes an initial
		 * URI, a chdir path, and an expected result URI.  It constructs
		 * a URI object using the initial URI string, then chdirs to
		 * the directory specified by 'chPath'.  The expected result is
		 * in 'expectedURI'.  This also performs some tests using
		 * makeAbsoluteURI() and makeRelativeURI() because we have all
		 * the necessary data to exercise all of these.
		 * 
		 * @param inURI	the initial URI
		 * @param chPath	the path to "cd" to.
		 * @param expectedURI	the expected result of executing the "cd" on inURI.
		 * @param skipAbsRelTests	if true, this will skip the makeAbsolute
		 *     and makeRelative tests.  The only time you would want to pass
		 *     true is when inURI is relative.
		 */
		private function doTestChDir(inURI:String, chPath:String,
			expectedURI:String, skipAbsRelTests:Boolean = false) : void
		{
			var uri:URI = new URI(inURI);
		
			assertEquals("chdir() sanity check", inURI, uri.toString());
		
			uri.chdir(chPath);
		
			assertEquals("chdir() failed.", expectedURI, uri.toString());
		
			// We have enough info to do absolute and relative operations, so
			// lets do those too, but only if it makes sense to do them. 
			// This function may be called with all relative paths (testing
			// chdir for cases using only relative paths).  We don't want to
			// do makeAbsoluteURI() and makeRelativeURI() tests in that case.
			if (skipAbsRelTests)
			{
				// Caller knows the input is not appropriate for makeRelative and
				// makeAbsolute.  Just stop here.
				return;
			}
		
			/////////////////////////////////////////////////////////////////
			// Test makeAbsoluteURI
			var abs:URI = new URI(inURI);
			var rel:URI = new URI(chPath);
		
			// Make sure we get out what we put in
			assertEquals("Absolute URI failed to parse.", inURI, abs.toString());
			assertEquals("chPath failed to parse.", chPath, rel.toString());
		
			rel.makeAbsoluteURI(abs);
			assertEquals("makeAbsoluteURI() failed.", expectedURI, rel.toString());
			
			// Make sure the passed URI didn't get modified.
			assertEquals("ERROR! makeAbsoluteURI() modified the passed URI.", inURI, abs.toString());
	
			
			/////////////////////////////////////////////////////////////////
			// Test makeRelativeURI
			var toRel:URI = new URI(expectedURI);
			var base:URI = new URI(inURI);
			var path:URI = new URI(chPath);
		
				// Make sure we get out what we put in
			assertEquals("expectedURI failed to parse.", expectedURI, toRel.toString());
		
			toRel.makeRelativeURI(base);
			
			// verification that makeRelativeURI() did what it was supposed to
			// do is handled below.
			
			// Make sure the passed URI didn't get modified
			assertEquals("ERROR! makeRelativeURI modified the passed URI.", inURI, base.toString());
		
			/////////////////////////////////////////////////////////////////
			// We should be back to the relative path we were given.
			// To test this, we ChDir on the inURI with the relative
			// path we generated and the one we were given.  If the
			// result is the same, we are good.  The reason we can't
			// directly compare the two is because often we are given
			// "./file" as the chPath, but we will generate "file"
			var test1:URI = new URI(inURI);
			var test2:URI = new URI(inURI);
				
			test1.chdir(toRel.toString());
			test2.chdir(chPath);
		
			assertTrue("Relative path verification failed.", test1.getRelation(test2) == URI.EQUAL);
		}
		
		// Interface for IURIResolver
		public function resolve(uri:URI) : URI
		{
			if (uri == null)
				return null;
				
			if (uri.authority == "test.org")
				uri.authority = "test.com";
				
			return uri;
		}
		
	} // end class
} // end package