/* Copyright (C) 2011 by Mosalam Ebrahimi <m.ebrahimi@ieee.org>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
*/

#include <Servo.h>

Servo fs;

const int servo_pin = 9;
const int baud = 9600;
const int servo_delay = 120;
const int min_degree = 0;
const int max_degree = 180;
int val = 0;

bool processIntString(int& val)
{
  int readVal = Serial.read();
  
  if ((readVal >= '0') &&
      (readVal <= '9')) {
    val *= 10;
    val += readVal - '0';
    return false;
  } else if (readVal == ';') {
    return true;
  }
}

int servoSafeguard(int val)
{
  if (val < min_degree)
    val = min_degree;
  else if (val > max_degree)
    val = max_degree;
   return val; 
}

void setup()
{
  fs.attach(servo_pin);
  
  Serial.begin(baud);
  Serial.println("command format: <degree>;");
  Serial.println("e.g.: 90;");
}

void loop()
{ 
  bool res = false;
  
  if (Serial.available())
    res = processIntString(val); 
 
  if (res == true) {
    val = servoSafeguard(val);
    fs.write(val);
    Serial.println(val);
    val = 0;
  }
  delay(servo_delay);
}

