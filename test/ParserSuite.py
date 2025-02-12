import unittest
from TestUtils import TestParser

class ParserSuite(unittest.TestCase):
    def test_simple_program(self):
        """Simple program: void main() {} """
        input = """func main() {};"""
        expect = "successful"
        self.assertTrue(TestParser.checkParser(input,expect,201))

    def test_more_complex_program(self):
        """More complex program"""
        input = """func foo () {
        };"""
        expect = "successful"
        self.assertTrue(TestParser.checkParser(input,expect,202))
    
    def test_wrong_miss_close(self):
        """Miss ) void main( {}"""
        input = """func main({};"""
        expect = "Error on line 1 col 11: {"
        self.assertTrue(TestParser.checkParser(input,expect,203))
    def test_wrong_variable(self):
        input = """var int;"""
        expect = "Error on line 1 col 5: int"
        self.assertTrue(TestParser.checkParser(input,expect,204))
    def test_wrong_index(self):
        input = """var i ;"""
        expect = "Error on line 1 col 7: ;"
        self.assertTrue(TestParser.checkParser(input,expect,205))
    def test_vardecl(self):
        input = """var i string;"""
        expect = "successful"
        self.assertTrue(TestParser.checkParser(input,expect,206))
    def test_func_vardecl(self):
        input = """func foo(x,y int,z float){}
        func foo(x,y int,z float){}"""
        expect = "successful"
        self.assertTrue(TestParser.checkParser(input,expect,207))
    def test_program_1(self):
        input = """var i = 2;
const a = 9+2*7
func main(){
    var a int;
    var b float;
    return a+b;
}
func foo(a,b,c int, d float) [5][3]float{
    return foo(a,b,c,d)
}"""
        expect = "successful"
        self.assertTrue(TestParser.checkParser(input,expect,208))
    def test_program_2(self):
        input = """
func main(){
arr := 1
for index, value := range arr {
// index: 0, 1, 2
// value: 10, 20, 30

}
}"""
        expect = "successful"
        self.assertTrue(TestParser.checkParser(input,expect,209))
    def test_program_3(self):
        input = """type Calculator interface {
Add(x, y int) int;
Subtract(a, b float, c int) float;
Reset()
SayHello(name string)
}
"""
        expect = "successful"
        self.assertTrue(TestParser.checkParser(input,expect,210))