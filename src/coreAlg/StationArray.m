classdef  StationArray
    properties
        nTotStations = 7;
        vStations=[];
    end

    methods
        function obj = StationArray(dataDir, interpMethod)
            obj.nTotStations=7;
            obj.vStations = Station.empty(obj.nTotStations, 0);
            obj.vStations(1) = Station('AmundsenScott', 'AYM00089009-data', 2835, dataDir, interpMethod );
            obj.vStations(2) = Station('Rothera', 'AYM00089062-data', 16.0, dataDir, interpMethod );
            obj.vStations(3) = Station('Neumayer', 'AYM00089002-data', 43.0, dataDir, interpMethod );
            obj.vStations(4) = Station('Syowa', 'AYM00089532-data', 29.0, dataDir, interpMethod );
            obj.vStations(5) = Station('McMurdo', 'AYM00089664-data', 10.0, dataDir, interpMethod );
            obj.vStations(6) = Station('Davis', 'AYM00089571-data', 27.0, dataDir, interpMethod );
            obj.vStations(7) = Station('Casey', 'AYM00089611-data', 32.0, dataDir, interpMethod );
        end

        function s = getStation(obj, idx)
            assert( idx>=1 && idx<=obj.nTotStations, 'error: index is out of boundary!');
            s = obj.vStations(idx);
        end

    end
end