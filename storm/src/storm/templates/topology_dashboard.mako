## Licensed to the Apache Software Foundation (ASF) under one
## or more contributor license agreements.  See the NOTICE file
## distributed with this work for additional information
## regarding copyright ownership.  The ASF licenses this file
## to you under the Apache License, Version 2.0 (the
## "License"); you may not use this file except in compliance
## with the License.  You may obtain a copy of the License at
##
## http:# www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.

<%!
   from desktop.views import commonheader, commonfooter
   from django.utils.translation import ugettext as _
%>

${commonheader("Topology Stats Detail", app_name, user) | n,unicode}

<%namespace name="storm" file="navigation_bar.mako" />
<%namespace name="Templates" file="templates.mako" />
<%namespace name="JavaScript" file="js.mako" />
<%namespace name="graphsHUE" file="common_dashboard.mako" />

## Use double hashes for a mako template comment
## Main body

<link href="/storm/static/css/storm.css" rel="stylesheet">

<style>
   .dataTables_length {
      width: 50%;
      float: left;
      text-align: left;
      vertical-align:top;
   } 
   .dataTables_filter {
      width: 50%;
      float: right;
      text-align: right;
      vertical-align:top;
   }   
</style>

${ graphsHUE.import_charts() }

<script type="text/javascript" charset="utf-8">                     
   $(document).ready(function() {  
      
   });
   
   var dataPieStatsEmitted = []
   var dataPieStatsTransferred = []
   var dataPieStatsAcked = []
   var dataPieStatsFailed = []
   var dataBarStats = []
   
   var sData = "${jStats}";   
   var swData = sData.replace(/&quot;/ig,'"')   
   var jsonStats = JSON.parse(swData);            
      
   for (var i=0; i<Object.keys(jsonStats).length; i++) {      
      dataPieStatsEmitted.push({"label": jsonStats[i].windowPretty, "value" : jsonStats[i].emitted});
      dataPieStatsTransferred.push({"label": jsonStats[i].windowPretty, "value" : jsonStats[i].transferred});
      dataPieStatsAcked.push({"label": jsonStats[i].windowPretty, "value" : jsonStats[i].acked});
      dataPieStatsFailed.push({"label": jsonStats[i].windowPretty, "value" : jsonStats[i].failed});
      dataBarStats.push({"key": jsonStats[i].windowPretty, "values": [ {"x": "Emitted", "y": jsonStats[i].emitted},
                                                                       {"x": "Transferred", "y": jsonStats[i].transferred},
                                                                       {"x": "Acked", "y": jsonStats[i].acked},
                                                                       {"x": "Failed", "y": jsonStats[i].failed}
                                                     ]
                        });
   }           
   
   var dataPieSpouts1 = [];
   var dataBarSpouts1 = [];
   var iTasks = 0;
   var iExecutors = 0;
   
   var sData = "${jSpouts}";   
   var swData = sData.replace(/&quot;/ig,'"')   
   var jsonSpouts = JSON.parse(swData);
   
   for (var i=0; i<Object.keys(jsonSpouts).length; i++) {
      iTasks+=jsonSpouts[i].tasks;
      iExecutors+=jsonSpouts[i].executors;     
      dataBarSpouts1.push({"key": jsonSpouts[i].spoutId, "values": [ {"x": "Emitted", "y": jsonSpouts[i].emitted},
                                                                     {"x": "Transferred", "y": jsonSpouts[i].transferred},
                                                                     {"x": "Acked", "y": jsonSpouts[i].acked},
                                                                     {"x": "Failed", "y": jsonSpouts[i].failed}
                                                                   ]
                          });
      
   };
   
   dataPieSpouts1.push({"label": "Tasks", "value" : iTasks}, {"label": "Executors", "value" : iExecutors});            
   
   var dataPieBolts1 = [];
   var dataBarBolts1 = [];
   var dataBarBolts2 = [];
   iTasks = 0;
   iExecutors = 0;
   
   var sData = "${jBolts}";   
   var swData = sData.replace(/&quot;/ig,'"')   
   var jsonBolts = JSON.parse(swData);
   
   for (var i=0; i<Object.keys(jsonBolts).length; i++) {
      iTasks+=jsonBolts[i].tasks;
      iExecutors+=jsonBolts[i].executors;
      
      dataBarBolts1.push({"key": jsonBolts[i].boltId, "values": [ {"x": "Emitted", "y": jsonBolts[i].emitted},
                                                                   {"x": "Transferred", "y": jsonBolts[i].transferred},
                                                                   {"x": "Acked", "y": jsonBolts[i].acked},
                                                                   {"x": "Failed", "y": jsonBolts[i].failed}
                                                                 ]
                          });
      dataBarBolts2.push({"key": jsonBolts[i].boltId, "values": [ {"x": "Execute Latency (ms)", "y": jsonBolts[i].executeLatency},
                                                                  {"x": "Process Latency (ms)", "y": jsonBolts[i].processLatency}
                                                                 ]
                          });                    
   }
   
   dataPieBolts1.push({"label": "Tasks", "value" : iTasks}, {"label": "Executors", "value" : iExecutors});
   
   nv.addGraph(function() {
                  var chart = nv.models.pieChart()
                                       .x(function(d) { return d.label })
                                       .y(function(d) { return d.value })                                       
                                       .showLabels(false);

                  d3.select("#pieStatsEmitted svg")
                    .datum(dataPieStatsEmitted)
                    .transition().duration(350)
                    .call(chart);
 
                  return chart;
   });
   
   nv.addGraph(function() {
                  var chart = nv.models.pieChart()
                                       .x(function(d) { return d.label })
                                       .y(function(d) { return d.value })                                       
                                       .showLabels(false);

                  d3.select("#pieStatsTransferred svg")
                    .datum(dataPieStatsTransferred)
                    .transition().duration(350)
                    .call(chart);
 
                  return chart;
   });
   
   nv.addGraph(function() {
                  var chart = nv.models.pieChart()
                                       .x(function(d) { return d.label })
                                       .y(function(d) { return d.value })                                       
                                       .showLabels(false);

                  d3.select("#pieStatsAcked svg")
                    .datum(dataPieStatsAcked)
                    .transition().duration(350)
                    .call(chart);
 
                  return chart;
   });
   
   nv.addGraph(function() {
                  var chart = nv.models.pieChart()
                                       .x(function(d) { return d.label })
                                       .y(function(d) { return d.value })                                       
                                       .showLabels(false);

                  d3.select("#pieStatsFailed svg")
                    .datum(dataPieStatsFailed)
                    .transition().duration(350)
                    .call(chart);
 
                  return chart;
   });      
   
   nv.addGraph(function() {
                 var graphStats = nv.models.multiBarChart()
                                           .transitionDuration(350)
                                           .reduceXTicks(true)   //If 'false', every single x-axis tick label will be rendered.
                                           .rotateLabels(0)      //Angle to rotate x-axis labels.                                           
                                           .groupSpacing(0.1)    //Distance between each group of bars.                                
                                           .showControls(true);
                                  
                                  graphStats.multibar.stacked(false);         
    
                                  graphStats.yAxis
                                            .tickFormat(d3.format('d'));
        
                                  d3.select('#barTopologyStats svg')
                                    .datum(dataBarStats)
                                    .call(graphStats);

                                  nv.utils.windowResize(graphStats.update);

                                  return graphStats;
   });      
                  
   nv.addGraph(function() {
                  var chart = nv.models.pieChart()
                                       .x(function(d) { return d.label })
                                       .y(function(d) { return d.value })
                                       .color(['#468847', '#f89406'])
                                       .showLabels(false);

                  d3.select("#pieSpouts1 svg")
                    .datum(dataPieSpouts1)
                    .transition().duration(350)
                    .call(chart);
 
                  return chart;
   });   
   
   nv.addGraph(function() {
                 var graphSpouts1 = nv.models.multiBarChart()
                                           .transitionDuration(350)
                                           .reduceXTicks(true)   //If 'false', every single x-axis tick label will be rendered.
                                           .rotateLabels(0)      //Angle to rotate x-axis labels.                                           
                                           .groupSpacing(0.1)    //Distance between each group of bars.                                
                                           .showControls(true);
                                  
                                  graphSpouts1.multibar.stacked(false);         
    
                                  graphSpouts1.yAxis
                                            .tickFormat(d3.format('d'));
        
                                  d3.select('#barSpouts1 svg')
                                    .datum(dataBarSpouts1)
                                    .call(graphSpouts1);

                                  nv.utils.windowResize(graphSpouts1.update);

                                  return graphSpouts1;
   });
   
   var dataPieSpouts2 = [ { "label": "Active",                               
                               "value" : 1
                             },
                             { "label": "Inactive",                               
                               "value" : 3
                             }
                           ];
                  
   nv.addGraph(function() {
                  var chart = nv.models.pieChart()
                                       .x(function(d) { return d.label })
                                       .y(function(d) { return d.value })
                                       .color(['#468847', '#f89406'])
                                       .showLabels(false);

                  d3.select("#pieSpouts2 svg")
                    .datum(dataPieSpouts2)
                    .transition().duration(350)
                    .call(chart);
 
                  return chart;
   });
      
   nv.addGraph(function() {
                  var chart = nv.models.pieChart()
                                       .x(function(d) { return d.label })
                                       .y(function(d) { return d.value })
                                       .color(['#468847', '#f89406'])
                                       .showLabels(false);

                  d3.select("#pieBolts1 svg")
                    .datum(dataPieBolts1)
                    .transition().duration(350)
                    .call(chart);
 
                  return chart;
   });          
   
   nv.addGraph(function() {
                 var graphBolts1 = nv.models.multiBarChart()
                                           .transitionDuration(350)
                                           .reduceXTicks(true)   //If 'false', every single x-axis tick label will be rendered.
                                           .rotateLabels(0)      //Angle to rotate x-axis labels.                                           
                                           .groupSpacing(0.1)    //Distance between each group of bars.                                
                                           .showControls(true);
                                  
                                  graphBolts1.multibar.stacked(false);         
    
                                  graphBolts1.yAxis
                                            .tickFormat(d3.format('d'));
        
                                  d3.select('#barBolts1 svg')
                                    .datum(dataBarBolts1)
                                    .call(graphBolts1);

                                  nv.utils.windowResize(graphBolts1.update);

                                  return graphBolts1;
   });      
                  
   nv.addGraph(function() {
                 var graphbarBolts2 = nv.models.multiBarChart()
                                           .transitionDuration(350)
                                           .reduceXTicks(true)   //If 'false', every single x-axis tick label will be rendered.
                                           .rotateLabels(0)      //Angle to rotate x-axis labels.                                           
                                           .groupSpacing(0.1)    //Distance between each group of bars.                                
                                           .showControls(true);
                                  
                                  graphbarBolts2.multibar.stacked(false);         
    
                                  graphbarBolts2.yAxis
                                                .tickFormat(d3.format('d'));
        
                                  d3.select('#barBolts2 svg')
                                    .datum(dataBarBolts2)
                                    .call(graphbarBolts2);

                                  nv.utils.windowResize(graphbarBolts2.update);

                                  return graphbarBolts2;   
   });
</script>

<%
  _breadcrumbs = [
    ["Storm Dashboard", url('storm:storm_dashboard')],    
    ["Topology " + Topology[0] + " Detail", url('storm:detail_dashboard', topology_id = Topology[0], system_id = 0)],
    ["Topology Stats Detail", url('storm:topology_dashboard', topology_id = Topology[0], window_id = windowId)]
  ]
%>

${ storm.header(_breadcrumbs) }

${ storm.menubar(section = 'Topology Stats Detail')}

${Templates.tblSubmitTopology(frmNewTopology)}
${Templates.tblSaveTopology(frmHDFS)}

<div id="divPrincipal" class="container-fluid">
  <div class="card">        
    <div class="card-body">
       <table width="100%" height="100%" border="0" cellpadding="6" cellspacing="0">
          ${Templates.ControlPanelTopology("topology_dashboard")} 
          <tr>
             <td colspan="3">                
                ${Templates.tblRebalanceTopology(Topology[1])}
             </td>
          </tr>                                        
          <tr>
             <td colspan="3">
                <div class="col-lg-4">
                   <div class="panel panel-default">
                      <div class="panel-heading">
                         <i class="fa fa-pie-chart fa-fw"></i> Topologies Stats
                      </div>
                      <div class="panel-body">
                         <table width="100%" height="100%" border="0" cellpadding="6" cellspacing="0">
                            <tr>
                               <td>
                                  <div id="pieStatsEmitted"><svg style="min-height: 240px; margin: 10px auto"></svg></div>
                               </td>
                               <td>
                                  <div id="pieStatsTransferred"><svg style="min-height: 240px; margin: 10px auto"></svg></div>
                               </td>
                               <td>
                                  <div id="pieStatsAcked"><svg style="min-height: 240px; margin: 10px auto"></svg></div>
                               </td>
                               <td>
                                  <div id="pieStatsFailed"><svg style="min-height: 240px; margin: 10px auto"></svg></div>
                               </td>
                            </tr>
                         </table>   
                      </div>                        
                   </div>
                </div>
             </td>
          </tr>
          <tr>
             <td colspan="3">
                <div class="col-lg-4">
                   <div class="panel panel-default">
                      <div class="panel-heading">
                         <i class="fa fa-bar-chart fa-fw"></i> Topologies Stats
                      </div>
                      <div class="panel-body">
                         <div id="barTopologyStats"><svg style="min-height: 240px; margin: 10px auto"></svg></div>
                      </div>                        
                   </div>
                </div>
             </td>
          </tr>
          <tr valign="top">
             <td>
                <div class="col-lg-4">
                   <div class="panel panel-default">
                      <div class="panel-heading">
                         <i class="fa fa-pie-chart fa-fw"></i> Spouts (Tasks/Executors)
                      </div>
                      <div class="panel-body">
                         <div id="pieSpouts1"><svg style="min-height: 220px; margin: 10px auto"></svg></div>
                      </div>                        
                   </div>
                </div>
             </td>
             <td colspan="2">
                <div class="col-lg-4">
                   <div class="panel panel-default">
                      <div class="panel-heading">
                         <i class="fa fa-bar-chart fa-fw"></i> Spouts Stats
                      </div>
                      <div class="panel-body">
                         <div id="barSpouts1"><svg style="min-height: 240px; margin: 10px auto"></svg></div>
                      </div>                        
                   </div>
                </div>
             </td>
             <!--
             <td>
                <div class="col-lg-4">
                   <div class="panel panel-default">
                      <div class="panel-heading">
                         <i class="fa fa-pie-chart fa-fw"></i> Spouts (Times)
                      </div>
                      <div class="panel-body">
                         <div id="pieSpouts2"><svg style="min-height: 220px; margin: 10px auto"></svg></div>
                      </div>                        
                   </div>
                </div>
             </td>
             -->
          </tr>
          <tr>
             <td width="25%">
                <div class="col-lg-4">
                   <div class="panel panel-default">
                      <div class="panel-heading">
                         <i class="fa fa-pie-chart fa-fw"></i> Bolts (Tasks/Executors)
                      </div>
                      <div class="panel-body">
                         <div id="pieBolts1"><svg style="min-height: 240px; margin: 10px auto"></svg></div>
                      </div>                        
                   </div>
                </div>
             </td>
             <td width="40%">
                <div class="col-lg-4">
                   <div class="panel panel-default">
                      <div class="panel-heading">
                         <i class="fa fa-bar-chart fa-fw"></i> Bolts Stats
                      </div>
                      <div class="panel-body">
                         <div id="barBolts1"><svg style="min-height: 240px; margin: 10px auto"></svg></div>
                      </div>                        
                   </div>
                </div>
             </td>
             <td width="35%">
                <div class="col-lg-4">
                   <div class="panel panel-default">
                      <div class="panel-heading">
                         <i class="fa fa-pie-chart fa-fw"></i> Bolts (Times)
                      </div>
                      <div class="panel-body">
                         <div id="barBolts2"><svg style="min-height: 240px; margin: 10px auto"></svg></div>
                      </div>                        
                   </div>
                </div>
             </td>
          </tr>
       </table>                                           
    </div>
  </div>
</div>

${commonfooter(messages) | n,unicode}
