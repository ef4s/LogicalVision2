//
// Created by peter on 08/06/16.
//

#include "simple_game.h"

simple_game(){

}

void next_frame(Mat frame){
    if(REC_BOTTOM_LEFT + REC_X >= DIM_X - 1){
        MOVE_LEFT = false;
    }

    if(REC_BOTTOM_LEFT - REC_X <= 0){
        MOVE_LEFT = true;
    }

    int offset = 1;
    if(!MOVE_LEFT){
        offset *= -1;
    }

    make_frame(offset, frame);
}

void make_frame(int offset, Mat frame){
    REC_BOTTOM_LEFT += offset;

    Point p1 = Point(REC_BOTTOM_LEFT, REC_BOTTOM_LEFT);
    Point p2 = Point(REC_BOTTOM_LEFT + REC_X, REC_BOTTOM_LEFT + REC_Y);

    void rectangle(frame, p1, p2, cv::BLACK, 1, 8, 0);
}