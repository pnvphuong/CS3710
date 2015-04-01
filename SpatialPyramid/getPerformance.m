function [acc] = getPerformance(perfTable)
	acc = getAccuracy(perfTable);
end

function acc = getAccuracy(perfTable)
	predTable = perfTable.prediction;
	groundTruthTable = perfTable.goldStandard;

	acc = sum(sum(predTable & groundTruthTable)) / (length(predTable) + length(groundTruthTable));
end