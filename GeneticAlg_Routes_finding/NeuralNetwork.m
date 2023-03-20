classdef NeuralNetwork < handle
   
    properties(Access=public)
        batchSize = 10;
        gamma = 0.99;
        decayRate = 0.99;
        numHiddenNeurons = 200;
        inputDims = 1 * 14;
        alpha = 1e-4;
        beta = 0.1;
        epsilon = 1e-5;
        theta = {}
        expectedG2 = {};
        gList= {};
        episodeNumber = 0;
        episodes = 0;
        rewardSum = 0;
        runningReward;
        numOfPrevStored = 10;
        previousObservations = {};
        previousHiddenValues = {};
        dlogps;
        gradBuffer = {};
        iteration;
        isTraining = false;
        numCycles = 0;
        prevCycles = [];
    end
    
    methods
        function obj = NeuralNetwork()
            if(exist('theta1.csv', 'File') && exist('theta2.csv', 'File'))
                obj.theta{end+1} = csvread('theta1.csv');
                obj.theta{end+1} = csvread('theta2.csv');
            else
                obj.theta{end+1} = rand(obj.numHiddenNeurons, obj.inputDims) ./ sqrt(obj.inputDims);
                obj.theta{end+1} = rand(1, obj.numHiddenNeurons) ./ sqrt(obj.numHiddenNeurons);
            end
            obj.expectedG2{end+1} = zeros(size(obj.theta{1}));
            obj.expectedG2{end+1} = zeros(size(obj.theta{2}));
            obj.gList{end+1} = zeros(size(obj.theta{1}));
            obj.gList{end+1} = zeros(size(obj.theta{2}));
            obj.gradBuffer{end+1} = zeros(obj.numHiddenNeurons, obj.inputDims);
            obj.gradBuffer{end+1} = zeros(1, obj.numHiddenNeurons);
        end
        
        function action = predict(self, input)
            if(self.isTraining)
                action = 1;
                return
            end
            [aProb, hiddenValues] = self.forprop(input);
            if(normrnd(0,1) < aProb) action = 1;
            else action = -1;
            end
            self.previousObservations{end+1} = input;
            self.episodeNumber = self.episodeNumber + 1;
            self.previousHiddenValues{end+1} = hiddenValues;
            if(action == 1) y = 1;
            else y = 0;
            end
            self.dlogps{end+1} = y - aProb;
            self.rewardSum = self.rewardSum + 0.1;
            self.numCycles = self.numCycles + 1;
        end
        
        function train(self)
            prevObsMat = self.convertToMat(self.previousObservations, self.inputDims)';
            prevHidValMat = self.convertToMat(self.previousHiddenValues, self.numHiddenNeurons)';
            costFuncLog = cell2mat(self.dlogps)';
            discountedRewards = self.genDiscountedRewards();
            discountedRewards = discountedRewards - mean(discountedRewards);
            discountedRewards = discountedRewards ./ std(discountedRewards);
            costFuncLog = costFuncLog .* discountedRewards';
            [grad1, grad2] = self.backprop(prevHidValMat, costFuncLog, prevObsMat);
            self.gradBuffer{1} = self.gradBuffer{1} + grad1;
            self.gradBuffer{2} = self.gradBuffer{2} + grad2;
            if (mod(self.episodes, self.batchSize) == 0)
                self.learn();
            end
            if (mod(self.episodes, 100) == 0)
                self.dumpToFile();
            end
            self.episodes = self.episodes + 1;
            self.episodeNumber = self.episodeNumber + 1;
            self.previousObservations = {};
            self.previousHiddenValues = {};
            self.dlogps = {};
            self.rewardSum = 0;
            self.prevCycles(end+1) = self.numCycles;
            self.numCycles = 0;
        end
    end
    
    methods(Access=private)
        
        function dumpToFile(self)
            dlmwrite('theta1.csv', self.theta{1});
            dlmwrite('theta2.csv', self.theta{2});
        end
        
        function [dW1, dW2] = backprop(self, prevHidValMat, costFuncLog, prevObsMat)
            dW2 = (prevHidValMat' * costFuncLog)';
            dh = costFuncLog * self.theta{2};
            dh(dh<0) = 0;
            dW1 = dh' * prevObsMat;
        end
        
        function learn(self)
            for ii = 1:2
                self.expectedG2{ii} = self.decayRate * self.expectedG2{ii} + (1-self.decayRate) * self.gradBuffer{ii};
                self.theta{ii} = self.theta{ii} - self.alpha * self.gradBuffer{ii} ./ (sqrt(self.expectedG2{ii} + self.epsilon));
            end
        end
        
        function [probMoveUp, hiddenVals] = forprop(self, input)
            hiddenVals = self.sigmoid(input * self.theta{1}');
            probMoveUp = self.sigmoid(hiddenVals * self.theta{2}');
        end
        
        function discRewards = genDiscountedRewards(self)
            discRewards = ones(1, self.numCycles);
            [~, zScore] = self.getZScore();
            rewards = zScore * discRewards - self.beta;
            
            k = numel(rewards);
            for ii = 1:k
                discRewards(ii) = rewards(ii) * (self.gamma ^ (k-ii));
            end
        end
        
        function [meanScore, zScore] = getZScore(self)
            meanScore =  mean(self.prevCycles);
            if isnan(meanScore)
                zScore = 0;
                return
            end
            zScore = (self.numCycles - meanScore) / std(self.prevCycles);
        end
        
        function ret = convertToMat(~, cellArray, numRows)
            ret = ones(numRows, length(cellArray));
            for ii = 1:length(cellArray)
                ret(:,ii) = cellArray{ii};
            end
        end
        
        function y = sigmoid(~, x)
           y = 1.0 ./ (1.0 + exp(-x)); 
        end
    end
end