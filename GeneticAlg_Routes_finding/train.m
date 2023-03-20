function [paddle1V, paddle2V] = train(PLOT_W, PLOT_H, BALL_RADIUS, ballX, ballY, ballSpeed, ballVector, paddle1, paddle2, winner, numFrame)
    persistent parameter;
    if isempty(parameter)
        parameter = 0;
    end
    p1T = paddle1(2,1);
    p1B = paddle1(2,3);
    p1L = paddle1(1,1);
    p1R = paddle1(1,2);
    ballwin1 = (winner == 1);
    
    % convert paddle2 player into paddle1 position: do a 180 rotate
%     p2T = PLOT_H - paddle2(2,3);
%     p2B = PLOT_H - paddle2(2,1);
%     p2L = PLOT_W - paddle2(1,2);
%     p2R = PLOT_W - paddle2(1,1);
%     ballX2 = PLOT_W - ballX;
%     ballY2 = PLOT_H - ballY;
%     ballVector2 = -ballVector;
%     ballwin2 = (winner == 2);
%     
    paddle1V = randi([-1, 1]);
    paddle2V = randi([-1, 1]);
    
end