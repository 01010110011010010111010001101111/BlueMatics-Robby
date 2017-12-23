#include "modules/states/spec_states/detector.h"

int all;
int newvalL;
int newvalR;
int valL;
int valR;

void pwmmaker(){
all=LIGHT_SENSOR_LEFT+LIGHT_SENSOR_RIGHT;
valL=all/2;
newvalL=100/LIGHT_SENSOR_LEFT*valL;
valR=all/2;
newvalR=100/LIGHT_SENSOR_RIGHT*valR;
}

pwmmaker();
//Data for left and right reversed, so that the robot can drive away from light
movement(newvalR,newvalL,1,1);