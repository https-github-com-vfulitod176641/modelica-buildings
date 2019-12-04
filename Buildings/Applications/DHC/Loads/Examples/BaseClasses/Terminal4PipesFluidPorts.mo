within Buildings.Applications.DHC.Loads.Examples.BaseClasses;
model Terminal4PipesFluidPorts
  extends Buildings.Applications.DHC.Loads.BaseClasses.PartialTerminalUnit(
    final nPorts1=2,
    final haveHeaPor=false,
    final haveFluPor=true,
    final haveFanPum=true,
    final haveEleHeaCoo=false,
    final m_flow1_nominal=abs(Q_flow_nominal ./ cp1_nominal ./ (T_a1_nominal - T_b1_nominal)));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPIDMinT(
    Ti=120,
    yMax=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    reverseAction=false,
    yMin=0) "PID controller for minimum temperature"
    annotation (Placement(transformation(extent={{-40,200},{-20,220}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow fan(
    redeclare each final package Medium = Medium2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=max(m_flow2_nominal),
    redeclare Fluid.Movers.Data.Generic per,
    nominalValuesDefineDefaultPressureCurve=true,
    dp_nominal=max(dp2_nominal),
    final allowFlowReversal=allowFlowReversal)
    annotation (Placement(transformation(extent={{90,-10},{70,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort THexInlMes(
    redeclare final package Medium = Medium2,
    final m_flow_nominal=m_flow2_nominal[1],
    final allowFlowReversal=allowFlowReversal)
    annotation (Placement(transformation(extent={{130,-10}, {110,10}})));
  Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU hexHea(
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2,
    final configuration=hexCon[1],
    final m1_flow_nominal=m_flow1_nominal[1],
    final m2_flow_nominal=m_flow2_nominal[1],
    final dp1_nominal=0,
    final dp2_nominal=dp2_nominal[1],
    final Q_flow_nominal=Q_flow_nominal[1],
    final T_a1_nominal=T_a1_nominal[1],
    final T_a2_nominal=T_a2_nominal[1],
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=allowFlowReversal)
    annotation (Placement(transformation(extent={{-80,4}, {-60,-16}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiFloNom1[nPorts1](
    k=m_flow1_nominal)
    annotation (Placement(transformation(extent={{160,200},{180,220}})));
  Modelica.Blocks.Sources.RealExpression Q_flowHea(y=hexHea.Q1_flow)
    annotation (Placement(transformation(extent={{160,170},{180,190}})));
  Fluid.HeatExchangers.DryCoilEffectivenessNTU hexCoo(
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2,
    final configuration=hexCon[2],
    final m1_flow_nominal=m_flow1_nominal[2],
    final m2_flow_nominal=m_flow2_nominal[2],
    final dp1_nominal=0,
    final dp2_nominal=dp2_nominal[2],
    final Q_flow_nominal=Q_flow_nominal[2],
    final T_a1_nominal=T_a1_nominal[2],
    final T_a2_nominal=T_a2_nominal[2],
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=allowFlowReversal) annotation (Placement(transformation(extent={{0,4},{
            20,-16}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPIDMaxT(
    Ti=120,
    yMax=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    reverseAction=true,
    yMin=0) "PID controller for maximum temperature"
    annotation (Placement(transformation(extent={{-40,150},{-20,170}})));
  Modelica.Blocks.Sources.RealExpression Q_flowCoo(y=hexCoo.Q1_flow)
    annotation (Placement(transformation(extent={{160,150},{180,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiFloNom2(k=max(m_flow2_nominal))
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant sigFlo2(k=1)
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
equation
  connect(THexInlMes.T, conPIDMinT.u_m)
    annotation (Line(points={{120,11},{120,180},{-30,180},{-30,198}}, color={0,0,127}));
  connect(fan.P, PFanPum) annotation (Line(points={{69,9},{60,9},{60,140},{220,140}},   color={0,0,127}));
  connect(ports_a1[1], hexHea.port_a1)
    annotation (Line(points={{-200,-220},{-100,-220},{-100,-12},{-80,-12}},
                                                                        color={0,127,255}));
  connect(conPIDMinT.y, gaiFloNom1[1].u) annotation (Line(points={{-18,210},{158,
          210}},                    color={0,0,127}));
  connect(gaiFloNom1.y, m_flow1Req) annotation (Line(points={{182,210},{202,210},
          {202,220},{220,220}}, color={0,0,127}));
  connect(hexCoo.port_b2, hexHea.port_a2) annotation (Line(points={{0,0},{-60,0}},     color={0,127,255}));
  connect(hexHea.port_b1, ports_b1[1])
    annotation (Line(points={{-60,-12},{-40,-12},{-40,-220},{200,-220}},
                                                                     color={0,127,255}));
  connect(ports_a1[2], hexCoo.port_a1)
    annotation (Line(points={{-200,-180},{-20,-180},{-20,-12},{0,-12}},
                                                            color={0,127,255}));
  connect(hexCoo.port_b1, ports_b1[2])
    annotation (Line(points={{20,-12},{40,-12},{40,-180},{200,-180}},
                                                               color={0,127,255}));
  connect(hexHea.port_b2, port_b2)
    annotation (Line(points={{-80,0},{-200,0}},                       color={0,127,255}));
  connect(conPIDMaxT.y, gaiFloNom1[2].u) annotation (Line(points={{-18,160},{140,
          160},{140,210},{158,210}}, color={0,0,127}));
  connect(THexInlMes.T, conPIDMaxT.u_m)
    annotation (Line(points={{120,11},{120,140},{-30,140},{-30,148}}, color={0,0,127}));
  connect(fan.port_a, THexInlMes.port_b) annotation (Line(points={{90,0},{110,0}},   color={0,127,255}));
  connect(port_a2, THexInlMes.port_a) annotation (Line(points={{200,0},{130,0}},                   color={0,127,255}));
  connect(fan.port_b, hexCoo.port_a2) annotation (Line(points={{70,0},{20,0}},                  color={0,127,255}));
  connect(uSet[1], conPIDMinT.u_s)
    annotation (Line(points={{-220,210},{-42,210}},                       color={0,0,127}));
  connect(uSet[2], conPIDMaxT.u_s)
    annotation (Line(points={{-220,230},{-132,230},{-132,160},{-42,160}}, color={0,0,127}));
  connect(Q_flowHea.y, Q_flow1Act[1])
    annotation (Line(points={{181,180},{192,180},{192,170},{220,170}}, color={0,0,127}));
  connect(Q_flowCoo.y, Q_flow1Act[2])
    annotation (Line(points={{181,160},{192,160},{192,190},{220,190}}, color={0,0,127}));
  connect(gaiFloNom2.u, sigFlo2.y)
    annotation (Line(points={{18,70},{-18,70}}, color={0,0,127}));
  connect(gaiFloNom2.y, fan.m_flow_in)
    annotation (Line(points={{42,70},{80,70},{80,12}}, color={0,0,127}));
end Terminal4PipesFluidPorts;