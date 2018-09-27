%% FM Synthesis plugin

classdef myFM < audioPlugin
    
    properties
        Amp = 1;
        ModI = 3;
    end
    
    properties (Dependent)
        FreqC = 440;
        FreqM = 200;
    end
    
     properties (Constant)
        PluginInterface = audioPluginInterface( ...
            audioPluginParameter('Amp','DisplayName','Amplitude','Mapping',{'lin',0,2}), ...
            audioPluginParameter('FreqC','DisplayName','Carrier Freq','Label','Hz','Mapping',{'log',10,20000}) ,...
            audioPluginParameter('FreqM','DisplayName','Mod Freq','Label','Hz','Mapping',{'lin',0,20000}) ,...
            audioPluginParameter('ModI','DisplayName','Mod Index','Label','Val','Mapping',{'lin',0,10}) ,...
            'InputChannels',1, 'OutputChannels',1)
     end
     
     properties (Access = private, Hidden)
        mOSC; 
        cOSC;
     end
     
     methods
        function obj = myFM()
            obj.mOSC = audioOscillator('sine', 'Frequency', 2);
            obj.cOSC = audioOscillator('sine', 'Frequency', 440);
        end

        function set.FreqC(obj, val)
            obj.cOSC.Frequency = val;
        end
        
        function val = get.FreqC(obj)
            val = obj.cOSC.Frequency;
        end
        
        function set.FreqM(obj, val)
            obj.mOSC.Frequency = val;
        end
        
        function val = get.FreqM(obj)
            val = obj.mOSC.Frequency;
        end

        function out = process (plugin,in)
           plugin.cOSC.SamplesPerFrame = size(in,1);
           plugin.mOSC.SamplesPerFrame = size(in,1);
 
           out = plugin.Amp * (plugin.cOSC() + (plugin.ModI * plugin.mOSC() )) .* in;
        end
     end
    
end

