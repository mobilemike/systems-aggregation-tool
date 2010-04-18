// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function generateHealthTooltips()
{
  $j('td.health_rank-column').live("mouseover", function()
  {
    var target = $j(this);
    if (target.data('qtip')) { return false; }
    $j(this).qtip(
    {
      content: {text: 'Loading...',
                url: '/cmdb/computers/' + $j(this).children('img').attr('alt') + '/health',
                prerender: false},
      position: {corner: {target: 'bottomLeft', tooltip: 'topLeft'},  adjust: {x: 35}},
      style: {name: 'light', 'width': '100%', 'font-size': 12, 'font-weight': 'normal', 'text-align': 'center'},
      show: {ready: true, solo: true, delay: 75, effect: {length: 75}},
      hide: {fixed: true, delay: 250, effect: {length: 75}}
    });
  });
}

function generateTextTooltips()
{
  $j('#as_computers-content th, span.tip').live("mouseover", function()
  {
    if($j(this).attr('title')) {
      var target = $j(this);
      if (target.data('qtip')) { return false; }
      $j(this).qtip(
        {
          content: {text: $j(this).attr('title')},
          position: {corner: {target: 'topMiddle', tooltip: 'bottomMiddle'}},
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

$j(document).ready(function()
{
  generateHealthTooltips();
  generateTextTooltips();
});