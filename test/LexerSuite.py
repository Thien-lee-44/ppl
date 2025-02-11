import unittest
from TestUtils import TestLexer

class LexerSuite(unittest.TestCase):
      
    def test_lower_identifier(self):
        """test identifiers"""
        self.assertTrue(TestLexer.checkLexeme("abc","abc,<EOF>",101))
    def test_wrong_token(self):
        self.assertTrue(TestLexer.checkLexeme("ab?sVN","ab,ErrorToken ?",102))
    def test_keyword_var(self):
        """test keyword var"""
        self.assertTrue(TestLexer.checkLexeme("var abc int ;","var,abc,int,;,<EOF>",103))
    def test_keyword_func(self):
        """test keyword func"""
        self.assertTrue(TestLexer.checkLexeme("""func abc ( ) ""","""func,abc,(,),<EOF>""",104))
    def test_illegal_escape(self):
        self.assertTrue(TestLexer.checkLexeme(""" "abcxyz\\h " ""","""Illegal escape in string: "abcxyz\\h""",105))
    def test_unclosed_string(self):
        self.assertTrue(TestLexer.checkLexeme(""" "abc
                                              d""","""Unclosed string: "abc""",106))
    def test_string_escape_1(self):
        self.assertTrue(TestLexer.checkLexeme(""" "abc\\"xyz"  """,""""abc\\"xyz",<EOF>""",107))
    def test_string_escape_2(self):
        self.assertTrue(TestLexer.checkLexeme(""" "abc\\\\xyz"  """,""""abc\\\\xyz",<EOF>""",108))
    def test_string_escape_3(self):
        self.assertTrue(TestLexer.checkLexeme(""" "abc\\rxyz"  """,""""abc\\rxyz",<EOF>""",109))
    def test_string_escape_4(self):
        self.assertTrue(TestLexer.checkLexeme(""" "abc\\txyz"  """,""""abc\\txyz",<EOF>""",110))
    def test_int(self):
        self.assertTrue(TestLexer.checkLexeme("""02372""","""0,2372,<EOF>""",111))
    def test_float(self):
        self.assertTrue(TestLexer.checkLexeme("""02.372""","""02.372,<EOF>""",112))
    def test_float_id(self):
        self.assertTrue(TestLexer.checkLexeme("""02.372asdas""","""02.372,asdas,<EOF>""",113))
    def test_comment_line(self):
        self.assertTrue(TestLexer.checkLexeme("""//02.372asdas
                                              //fasfsaf""","""<EOF>""",114))
    def test_comment_multi_line(self):
        self.assertTrue(TestLexer.checkLexeme(""" /*sc*//*s*//*vas*/ ""","""<EOF>""",115))
    def test_newline(self):
         self.assertTrue(TestLexer.checkLexeme("""abc;\ndef""","""abc,;,def,<EOF>""",116))
  
