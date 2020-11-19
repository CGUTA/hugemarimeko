#!/usr/bin/env python 
# -*- coding: utf-8 -*-
"""
Created on Fri Aug  7 14:56:01 2020

@author: Carlos
"""

import math
import numpy as np
import scipy.misc as smp
from PIL import Image

def get_segment(q1, q2, ratio):
        return(q1 + (q2 - q1) * ratio)

def render(yoffset, xt, color):
    x = xt + width//2
    y = yoffset
    im[x, y][0], im[x, y][1], im[x, y][2]= [int(x) for x in color.split("_")]

def process(yoffset, quantity1, quantity2, thickness, direction, color):
    
    
    for i in range(thickness):
        current_offset = yoffset + i
        print(current_offset)
        start = right_offset[current_offset] if direction == "UP" else left_offset[current_offset] - 1
        end = int(get_segment(quantity1, quantity2, i/thickness))
        
        if direction == "UP":
            sequence = range(start, start + end, 1)
            right_offset[current_offset] = end
            
        else:
            sequence = range(start, start - end, -1)
            left_offset[current_offset] = -end
            
        print(i, start, end)

        for j in sequence:
            render(current_offset, j, color)
            

def first_equal(myList, y):
    return(next((i for i, x in enumerate(myList) if x == y), None))
    
def furthest_drawn(a):
    indexes = [i for i, e in enumerate(a) if e != 0]
    if indexes != []:
        return(indexes[-1])
    else:
        return 0
        
width = int("$params.height")
height = int("$params.width")

im = np.full( (width+1,height+1,3), int("${params.background_greyscale}"), dtype=np.uint8)

with open("marimeko_processed.psv") as f:
    header = True
    
    yoffset = 0
    
    current_group = "no_group"
    
    left_offset = [0 for i in range(height)]
    right_offset = [0 for i in range(height)]
    
    for line in f:
        if header:
            header = False
            continue
        
        record = line.strip().split("|")
        
        group = record[0]
        lenght = int(record[1])
        quantity1 = int(record[2])
        quantity2 = int(record[3])
        direction = record[4]
        color = record[5]
        
        if current_group != group:
            print(group)
            
            yoffset = max(furthest_drawn(right_offset), furthest_drawn(left_offset)) + ${params.gap} + 1
            current_group = group
            
        process(yoffset, quantity1, quantity2, lenght, direction, color)
         
        
        
img = Image.fromarray(im)       # Create a PIL image
smp.imsave('marimeko_output.png', img) 