## Bracket sequence processing
#

import re

def is_balanced(text):
    opening = '([{'
    closing = ')]}'
    stack = []
    for char in text:
        if char in opening:
            stack.append(opening.index(char))
        elif char in closing:
            if stack and stack[-1] == closing.index(char):
                stack.pop()
            else:
                return False
    return (not stack)

def max_balanced(text):
    #Charcheck
    if re.sub(r"[a-zA-Z{}\[\]()]", "", text): return ('Incorrect characters! Accept only brackets and letters')

    #Const
    string = text+text
    opening = '([{'
    closing = ')]}'
    error = 0
    s_len = len(string)
    ss_max = 0
    x = 0
    y = 0
    result = ''

    #First infinite check
    new = re.sub(r"[a-zA-Z]", "", string)
    if new[0] in closing and new[len(new)-1] in opening and is_balanced(new[1:len(new)-1]):
           if closing.index(new[0]) == opening.index(new[len(new)-1]): error = 1

    #Find max substring
    if re.sub(r"[a-zA-Z{}\[\]()]", "", s1): print('Incorrect characters! Accept only brackets and letters')
    while x <= s_len and error == 0:
        substring = string[x:y]
        ss_len = len(substring)
        if is_balanced(substring):
            if ss_len >= ss_max:
                ss_max = ss_len
                result = substring
        y = y+1
        if y > s_len: 
            x = x+1
            y = 0

    #Second infinite check
    if result:
        if error == 1 or result == string or is_balanced(string.split(result)[1] + string.split(result)[0]): result = 'Infinite'

    return result

#pytest
def test_is_balanced():
    assert is_balanced('{x[x]x(x)}') == True
    assert is_balanced(']x[x]') == False

def test_max_balanced():
    assert max_balanced('{x[x]x(x)}') == 'Infinite'
    assert max_balanced('()}[(x)]{') == 'Infinite'
    assert max_balanced('}[(x)]{()') == 'Infinite'
    assert max_balanced(']x}[x]') == '[x]'
    assert max_balanced('xx}x({') == '{xx}x'
    assert max_balanced(')x)x(x[')

# The End
s1 = 'xx}x({xxxxx'
print(max_balanced(s1))