function dataOutput(ttotal, output, verification, validation, showenergy)

if showenergy
    figure('Name','Energy conservation results','Position',[200 200 600 325]);
    
    plot(ttotal,output.eK,'LineWidth',5);
    hold on;
    plot(ttotal,output.eS,'LineWidth',5);
    plot(ttotal,output.eS+output.eK,'k','LineWidth',5);
    xlabel('tempo');
    ylabel('energia');
    legend('energia cinética','energia de deformação','energia total');
end

if validation ~= 4
    switch validation
        case 1
            analyticalposition = verification.analyticalposition;

            %% ERROR CALCULATION:

            absoluteerror = abs(output.cmx-analyticalposition);

            %% PLOTTING RESULTS

            figure('Name','Comparison of results','Position',[200 200 800 325]);

            toPlot1 = subplot(1,2,1);
            plot(toPlot1,ttotal,analyticalposition,'LineWidth',5);
            hold on;
            plot(toPlot1,ttotal,output.cmx,'--','LineWidth',5);
            xlabel('tempo');
            ylabel('posição');
            legend(toPlot1,'analítico','numérico');

            toPlot2 = subplot(1, 2, 2);
            plot(toPlot2,ttotal,absoluteerror,'LineWidth',5);
            xlabel('tempo');
            ylabel('erro absoluto posição');

        case 2
            analyticaldisplacement = verification.analyticaldisplacement;

            %% ERROR CALCULATION:

            absoluteerror = abs(output.cmu-analyticaldisplacement);

            %% PLOTTING RESULTS

            figure('Name','Comparison of results','Position',[200 200 800 325]);

            toPlot1 = subplot(1, 2, 1);
            plot(toPlot1,ttotal,analyticaldisplacement,'LineWidth',5);
            hold on;
            plot(toPlot1,ttotal,output.cmu,'--','LineWidth',5);
            xlabel('tempo');
            ylabel('deslocamento');
            legend(toPlot1,'analítico','numérico');

            toPlot2 = subplot(1,2,2);
            plot(toPlot2,ttotal,absoluteerror,'LineWidth',5);
            xlabel('tempo');
            ylabel('erro absoluto deslocamento');

        case 3
            analyticalvelocity = verification.analyticalvelocity;

            %% ERROR CALCULATION:

            absoluteerror = abs(output.cmv-analyticalvelocity);

            %% PLOTTING RESULTS

            figure('Name','Comparison of results','Position',[200 200 800 325]);

            toPlot1 = subplot(1,2,1);
            plot(toPlot1,ttotal,analyticalvelocity,'LineWidth',5);
            hold on;
            plot(toPlot1,ttotal,output.cmv,'--','LineWidth',5);
            xlabel('tempo');
            ylabel('velocidade');
            legend(toPlot1,'analítico','numérico');

            toPlot2 = subplot(1,2,2);
            plot(toPlot2,ttotal,absoluteerror,'LineWidth',5);
            xlabel('tempo');
            ylabel('erro absoluto velocidade');

        otherwise
            error('INVALID VALIDATION OPTION');
    end
end

end