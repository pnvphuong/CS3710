% hard code the taxonomy structure
k = {'ibis', 'hawksbill', 'hummingbird', 'cormorant', 'duck', ...
    'goose', 'ostrich', 'owl', 'penguin', 'swan', ...
    'bat', 'bear', 'camel', 'chimp', 'dog', 'elephant', ...
    'elk', 'frog', 'giraffe', 'goat', 'gorilla', ...
    'horse', 'iguana', 'kangaroo', 'llama', ...
    'leopards', 'porcupine', 'raccoon', 'skunk', ...
    'snake', 'snail', 'zebra', 'greyhound', 'toad', ...
    'horseshoe-crab', 'crab', 'conch', 'dolphin', ...
    'goldfish', 'killer-whale', 'mussels', 'octopus', 'starfish', ...
    'air', ...
    'land', ...
    'water', ...
    'animal'};
v = {'114.ibis-101', '100.hawksbill-101', '113.hummingbird', '049.cormorant', '060.duck', ...
    '089.goose', '151.ostrich', '152.owl', '158.penguin', '207.swan', ...
    '007.bat', '009.bear', '028.camel', '038.chimp', '056.dog', '064.elephant-101', ...
    '065.elk', '080.frog', '084.giraffe', '085.goat', '090.gorilla', ...
    '105.horse', '116.iguana', '121.kangaroo-101', '134.llama-101', ...
    '129.leopards-101', '164.porcupine', '168.raccoon', '186.skunk', ...
    '190.snake', '189.snail', '250.zebra', '254.greyhound', '256.toad', ...
    '106.horseshoe-crab', '052.crab-101', '048.conch', '057.dolphin-101', ...
    '087.goldfish', '124.killer-whale', '148.mussels', '150.octopus', '201.starfish-101', ...
    {'ibis', 'hawksbill', 'hummingbird', 'cormorant', 'duck', ...
        'goose', 'ostrich', 'owl', 'penguin', 'swan' ...
    }, ...
    {'bat', 'bear', 'camel', 'chimp', 'dog', 'elephant', ...
        'elk', 'frog', 'giraffe', 'goat', 'gorilla', ...
        'horse', 'iguana', 'kangaroo', 'llama', ...
        'leopards', 'porcupine', 'raccoon', 'skunk', ...
        'snake', 'snail', 'zebra', 'greyhound', 'toad'...
    }, ...
    {'horseshoe-crab', 'crab', 'conch', 'dolphin', ...
        'goldfish', 'killer-whale', 'mussels', 'octopus', 'starfish'...
    }, ...
    {'air', 'land', 'water'}};


caltechTaxonomyMap = containers.Map(k,v);
save('caltechTaxonomy.mat', 'caltechTaxonomyMap');
% load('caltechTaxonomy.mat');