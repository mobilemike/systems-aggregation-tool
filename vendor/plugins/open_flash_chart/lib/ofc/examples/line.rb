module OFC
  module Examples
    module Line
      # http://teethgrinder.co.uk/open-flash-chart-2/data-lines.php
      def line
        #$title = new title( date("D M d Y") );
        title = OFC::Title.new(:text => Time.now.strftime("%a %b %d %Y"))

        #$line_dot = new line();
        #$line_dot->set_values( array(1,2,1,null,null,null,null,null) );
        line_dot = OFC::Line.new(:values => [1,2,1,nil,nil,nil,nil,nil])

        #$chart = new open_flash_chart();
        #$chart->set_title( $title );
        #$chart->add_element( $line_dot );
        chart = OFC::OpenFlashChart.new(:title => title, :elements => [line_dot])

        #echo $chart->toPrettyString();
        render :text => chart.render
      end
    end
  end
end
