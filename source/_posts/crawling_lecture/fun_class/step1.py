
# -*- coding: utf-8 -*-
import tensorflow

def cnt_letter():
    """문자를 세는 함수입니다.
    Args:
            content(str) : 탐색 문자열
            letter(str) : 찾을 문자열
    
    returns:
        int
    
    Raises:
        ValueError : 만약 Return값이 문자가 아니면 에러를 발생시킨다.
    """   
    
    print("함수 테스트!")
if (not isinstance(letter, str)) or len(letter) != 1:
    raise ValueError('`letter` 반드시 숫자여야 합니다.')
return (len([char for char in content if char == letter]))
    return None

if ___name___ == "__main__":
    print(cnt_letter())
    docstring = cnt_letter.__doc__

    border = '#' * 28
    print('{}\n{}\n{}'.format(border, docstring, border))

    cal = cnt_letter("abcdbacdbacba","a")
    print(cal)
    print("----")
    print(help(cnt_letter))












