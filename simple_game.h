//
// Created by peter on 08/06/16.
//

#ifndef LOGICALVISION2_SIMPLE_GAME_H
#define LOGICALVISION2_SIMPLE_GAME_H

#include <opencv2/core/core.hpp>
#include "opencv2/imgproc/imgproc.hpp"
#include <opencv2/highgui/highgui.hpp>

class simple_game {
    //simple game is a white square moving across a black background
    //it moves left until it hits the edge, then it moves right
    int DIM_X = 100;
    int DIM_Y = 100;

    bool MOVE_LEFT = true;

    int REC_X = 10;
    int REC_Y = 10;
    int REC_BOTTOM_LEFT = 45;

    int DDEPTH = CV_16S;

public:
    simple_game(){};
    void next_frame(Mat frame){};
private:
    void make_frame(int offset, Mat frame){};

};


#endif //LOGICALVISION2_SIMPLE_GAME_H
