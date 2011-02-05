// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function generateHealthTooltips() {
  $j('td.health-column').live("mouseover", function(event) {
    var target = $j(this);
    target.qtip({
      overwrite: false,
      content: {
        text: 'Loading...',
        ajax: {
          url: '/servers/' + target.children('img').attr('alt') + '/health'
        }
      },
      position: {
        my: 'top left',
        at: 'center',
        adjust: {
          x: -4,
          y: 10,
          screen: true
        }
      },
      show: {
        event: event.type,
        ready: true,
        delay: 250
      },
      hide: {
        fixed: true,
        delay: 250
      },
      style: {
        classes: 'ui-tooltip-shadow ui-tooltip-light ui-tooltip-ajax',
        tip: {
          mimic: 'top center'
        }
      }
    });
  },
  event);
}

function generateTextTooltips() {
  $j('.computers-view th, .issues-view th, span.tip').live("mouseover", function(event) {
    var target = $j(this);
    if(target.attr('title')) {
      target.qtip({
        overwrite: false,
        content: {
          text: target.attr('title')
        },
        position: {
          my: 'bottom center',
          at: 'top center',
          adjust: {
            y: -5,
            screen: true
          }
        },
        show: {
          event: event.type,
          ready: true,
          delay: 250
        },
        hide: {
          fixed: true,
          delay: 250
        },
        style: {
          classes: 'ui-tooltip-shadow ui-tooltip-dark ui-tooltip-text'
        }
      });
      target.attr({
        title: ""
      });
    }
  },
  event);
}

function generateComputerTooltips() {
  $j('td.fqdn-column').live("click", function(event) {
    var target = $j(this);
    target.qtip({
      overwrite: false,
      content: {
        text: 'Loading...',
        ajax: {
          url: target.children('a').attr('href')
        },
        title: {
          button: true
        }
      },
      position: {
        my: 'right center',
        at: 'right center',
        target: $j('#as-content-box'),
        adjust: {
          x: 0,
          screen: true
        }
      },
      show: {
        event: event.type,
        solo: true,
        ready: true,
        delay: 250
      },
      hide: {
        event: 'unfocus',
        fixed: true,
        delay: 250
      },
      style: {
        classes: 'ui-tooltip-shadow ui-tooltip-light ui-tooltip-ajax ui-tooltip-details'
      }
    });
    event.preventDefault();
  },
  event);
}

function toggleBoxes() {
  $j('h2 a.toggle').live('click', function(event) {
    $j(this).parent().nextAll('div').slideToggle('fast','swing');
    event.preventDefault();
  },
  event);
}

$j(document).ready(function()
{
  generateHealthTooltips();
  generateTextTooltips();
  generateComputerTooltips();
  toggleBoxes();
});