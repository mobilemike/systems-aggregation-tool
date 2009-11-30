module OFC
  module Examples
    module StackedBarChart  
      # http://teethgrinder.co.uk/open-flash-chart-2/stacked-bar-chart.php
      def stacked_bar_chart
        #$title = new title( 'Stuff I\'m thinking about, '.date("D M d Y") );
        #$title->set_style( "{font-size: 20px; color: #F24062; text-align: center;}" );
        title = OFC::Title.new(:text => "Stuff I'm thinking about", :style => "{font-size: 20px; color: #F24062; text-align: center;}")

        #$bar_stack = new bar_stack();
        #// set a cycle of 3 colours:
        #$bar_stack->set_colours( array( '#C4D318', '#50284A', '#7D7B6A' ) );
        bar_stack = OFC::BarStack.new(:colours => ['#C4D318', '#50284A', '#7D7B6A'])

        #// add 3 bars:
        #$bar_stack->append_stack( array( 2.5, 5, 2.5 ) );
        bar_stack.values = []
        bar_stack.values << [2.5,5,2.5]

        #// add 4 bars, the fourth will be the same colour as the first:
        #$bar_stack->append_stack( array( 2.5, 5, 1.25, 1.25 ) );
        bar_stack.values << [2.5,5,1.25,1.25]


        #$bar_stack->append_stack( array( 5, new bar_stack_value(5, '#ff0000') ) );
        # TODO figure out BarStackValue
        bar_stack.values << [5, { "val" => 5, "colour" => "#ff0000" }]
        #$bar_stack->append_stack( array( 2, 2, 2, 2, new bar_stack_value(2, '#ff00ff') ) );
        bar_stack.values << [2,2,2,2, { "val" => 2, "colour" => "#ff00ff" }]

        #$bar_stack->set_keys(
        #    array(
        #        new bar_stack_key( '#C4D318', 'Kiting', 13 ),
        #        new bar_stack_key( '#50284A', 'Work', 13 ),
        #        new bar_stack_key( '#7D7B6A', 'Drinking', 13 ),
        #        new bar_stack_key( '#ff0000', 'XXX', 13 ),
        #        new bar_stack_key( '#ff00ff', 'What rhymes with purple? Nurple?', 13 ),
        #        )
        #    );
        bar_stack.keys = [{ "colour" => "#C4D318", "text" => "Kiting", "font-size" => 13 },
                          { "colour" => "#50284A", "text" => "Work", "font-size" => 13 },
                          { "colour" => "#7D7B6A", "text" => "Drinking", "font-size" => 13 },
                          { "colour" => "#ff0000", "text" => "XXX", "font-size" => 13 },
                          { "colour" => "#ff00ff", "text" => "What rhymes with purple? Nurple?", "font-size" => 13 }]

        #$bar_stack->set_tooltip( 'X label [#x_label#], Value [#val#]<br>Total [#total#]' );
        bar_stack.tip = "X label [#x_label#], Value [#val#]<br>Total [#total#]"

        #$y = new y_axis();
        #$y->set_range( 0, 14, 2 );
        y = OFC::YAxis.new(:min => 0, :max => 14, :steps => 2)

        #$x = new x_axis();
        #$x->set_labels_from_array( array( 'Winter', 'Spring', 'Summer', 'Autmn' ) );
        x = OFC::XAxis.new(:labels => {:lables => ["Winter", "Spring", "Summer", "Autumn"]})

        #$tooltip = new tooltip();
        #$tooltip->set_hover();
        tooltip = OFC::Tooltip.new
        tooltip.mouse = 2

        #$chart = new open_flash_chart();
        #$chart->set_title( $title );
        chart = OFC::OpenFlashChart.new(:title => title)
        #$chart->add_element( $bar_stack );
        chart.elements = []
        chart.elements << bar_stack
        #$chart->set_x_axis( $x );
        chart.x_axis = x
        #$chart->add_y_axis( $y );
        chart.y_axis = y
        #$chart->set_tooltip( $tooltip );
        chart.tooltip = tooltip

        #echo $chart->toPrettyString(
        render :text => chart.render
      end
    end
  end
end
