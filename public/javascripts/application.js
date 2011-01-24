// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function generateHealthTooltips()
{
  $j('td.health-column').live("mouseover", function()
  {
    var target = $j(this);
    if (target.data('qtip')) { return false; }
    $j(this).qtip(
    {
      content: {text: 'Loading...',
                url: '/servers/' + $j(this).children('img').attr('alt') + '/health',
                prerender: false},
      position: {corner: {target: 'bottomLeft', tooltip: 'topLeft'},  adjust: {x: 35, screen: true}},
      style: {name: 'light', 'width': '100%', 'font-size': 12, 'font-weight': 'normal', 'text-align': 'center'},
      show: {ready: true, solo: true, delay: 75, effect: {length: 75}},
      hide: {fixed: true, delay: 250, effect: {length: 75}}
    });
  });
}

function generateTextTooltips()
{
  $j('.computers-view th, .issues-view th, span.tip').live("mouseover", function()
  {
    if($j(this).attr('title')) {
      var target = $j(this);
      if (target.data('qtip')) { return false; }
      $j(this).qtip(
        {
          content: {text: $j(this).attr('title')},
          position: {corner: {target: 'topMiddle', tooltip: 'bottomMiddle'}, adjust: {screen: true}},
          style: {name: 'dark', tip: 'bottomMiddle'},
          show: {ready: true}
        });
      $j(this).attr(
        {
          title: ""
        });
      };
  });
}

function generateComputerTooltips()
{
  $j('td.fqdn-column').live("click", function()
  {
    var target = $j(this);
    if (target.data('qtip')) { return false; }
    target.qtip(
    {
      content: {text: 'Loading...',
                url: target.children('a').attr('href'),
                prerender: false},
      position: {corner: {target: 'bottomLeft', tooltip: 'topLeft'},  adjust: {x: 35, screen: true}},
      style: {name: 'light', 'width': '100%', 'font-size': 12, 'font-weight': 'normal', 'text-align': 'center'},
      show: {ready: true, solo: true, delay: 75, effect: {length: 75}, when: {event: 'click' }},
      hide: {when: {event: 'unfocus'}, effect: {length: 75}}
    });
    target.children('a').attr(
      {
        href: '#'
      });
  });
}


$j(document).ready(function()
{
  generateHealthTooltips();
  generateTextTooltips();
  generateComputerTooltips();
});