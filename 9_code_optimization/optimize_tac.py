#!/usr/bin/env python3
"""
Usage:
  Provide TAC lines like:
    t1 = 2
    t2 = 3
    t3 = t1 + t2
    a = b * 2
    b = c * 0
"""
import re,sys

def parse(line):
    line=line.strip()
    if not line: return None
    # forms: x = y op z  or x = CONST or x = y
    m=re.match(r'(\w+)\s*=\s*(\w+)\s*([\+\-\*\/])\s*(\w+)', line)
    if m: return ('bin', m.groups())
    m2=re.match(r'(\w+)\s*=\s*(\d+(\.\d+)?)$', line)
    if m2: return ('const', (m2.group(1), m2.group(2)))
    m3=re.match(r'(\w+)\s*=\s*(\w+)$', line)
    if m3: return ('copy', m3.groups())
    return ('other', line)

def optimize(lines):
    consts = {}   # name -> value
    out=[]
    for line in lines:
        p=parse(line)
        if not p: continue
        t = p[0]
        if t=='const':
            var,val = p[1]
            consts[var]=val
            out.append(f"{var} = {val}")
        elif t=='bin':
            dest, a, op, b = p[1]
            # constant folding
            if a in consts and b in consts:
                av=float(consts[a]); bv=float(consts[b])
                if op=='+': res=av+bv
                elif op=='-': res=av-bv
                elif op=='*': res=av*bv
                elif op=='/': res=av/bv if bv!=0 else None
                if res is not None:
                    consts[dest]=str(int(res) if res.is_integer() else res)
                    out.append(f"{dest} = {consts[dest]}  # folded")
                    continue
            # strength reduction: x * 2 -> x + x
            if op=='*' and b=='2':
                out.append(f"{dest} = {a} + {a}  # strength-reduced")
                continue
            # algebraic simplification
            if op=='*' and (a=='0' or b=='0'):
                out.append(f"{dest} = 0  # algebraic simplify")
                consts[dest]='0'
                continue
            if op=='+' and a=='0':
                out.append(f"{dest} = {b}  # simplify")
                continue
            if op=='+' and b=='0':
                out.append(f"{dest} = {a}  # simplify")
                continue
            out.append(line)
        else:
            out.append(line)
    return out

if __name__=="__main__":
    if len(sys.argv)>1:
        with open(sys.argv[1]) as f: lines=f.readlines()
    else:
        lines = sys.stdin.read().splitlines()
    optimized = optimize(lines)
    print("\n".join(optimized))
