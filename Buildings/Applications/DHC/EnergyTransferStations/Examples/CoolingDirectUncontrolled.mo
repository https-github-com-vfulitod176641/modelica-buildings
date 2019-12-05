within Buildings.Applications.DHC.EnergyTransferStations.Examples;
model CoolingDirectUncontrolled
  "Example model for the direct cooling energy transfer station with uncontrolled district-building fluid transfer within the ETS"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water;

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = 15000
    "Nominal cooling load";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = Q_flow_nominal/(cp*(16 - 7))
    "Nominal mass flow rate";

 parameter Modelica.SIunits.SpecificHeatCapacity cp=
   Medium.specificHeatCapacityCp(
      Medium.setState_pTX(Medium.p_default, Medium.T_default, Medium.X_default))
    "Default specific heat capacity of medium";

  Buildings.Applications.DHC.EnergyTransferStations.CoolingDirectUncontrolled coo(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpSup=500,
    dpRet=500)
    "Direct cooling energy transfer station"
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));

  Buildings.Fluid.Sources.Boundary_pT souDis(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 300000 + 800,
    use_T_in=true,
    T=280.15,
    nPorts=1)
    "District (primary) source"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

  Buildings.Fluid.Sources.Boundary_pT sinDis(
    redeclare package Medium = Medium,
    p=300000,
    T=289.15,
    nPorts=1)
    "District-side (primary) sink"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TDisSup(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    T_start=280.15)
    "District-side (primary) supply temperature sensor"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TDisRet(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    T_start=289.15)
    "District-side (primary) return temperature sensor"
    annotation (Placement(transformation(extent={{-40,-100},{-60,-80}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TBuiRet(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    T_start=289.15)
    "Building-side (secondary) return temperature sensor"
    annotation (Placement(transformation(extent={{60,-100},{40,-80}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TBuiSup(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    T_start=280.15)
    "Building-side (secondary) supply temperature sensor"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));

  Buildings.Fluid.HeatExchangers.HeaterCooler_u loa(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_nominal,
    from_dp=false,
    linearizeFlowResistance=true,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    Q_flow_nominal=-1,
    dp_nominal=100)
    "Aggregate building cooling load"
    annotation (Placement(transformation(extent={{80,-20},{100,0}})));

  Modelica.Blocks.Sources.RealExpression dT(y=TDisRet.T - TDisSup.T)
    "Temperature change across ETS (measured at district side)"
    annotation (Placement(transformation(extent={{80,100},{130,120}})));

  Modelica.Blocks.Sources.CombiTimeTable QCoo(
    table=[0,-10E3; 6,-8E3; 6,-5E3; 12,-2E3; 18,-15E3; 24,-10E3],
    timeScale=3600,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Cooling demand"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));

  Modelica.Blocks.Sources.Ramp ram(
    height=1,
    duration(displayUnit="h") = 18000,
    startTime(displayUnit="h") = 3600)
    "Ramp load from zero"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

  Modelica.Blocks.Math.Product pro
    "Multiplyer to ramp load from zero"
    annotation (Placement(transformation(extent={{40,46},{60,66}})));

  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=50,
    riseTime=10)
    "In-building terminal control valve"
    annotation (Placement(transformation(extent={{120,-20},{140,0}})));

  Modelica.Blocks.Sources.RealExpression Q_flow_max(y=-Q_flow_nominal)
    "Maximum Q_flow"
    annotation (Placement(transformation(extent={{-40,68},{-20,88}})));

  Modelica.Blocks.Math.Division division
    annotation (Placement(transformation(extent={{0,74},{20,94}})));

  Modelica.Blocks.Sources.Trapezoid tra(
    amplitude=2,
    rising(displayUnit="h") = 10800,
    width(displayUnit="h") = 10800,
    falling(displayUnit="h") = 10800,
    period(displayUnit="h") = 43200,
    offset=273 + 6)
    "District supply temperature trapezoid signal"
    annotation (Placement(transformation(extent={{-140,-16},{-120,4}})));

equation
  connect(tra.y, souDis.T_in)
    annotation (Line(points={{-119,-6},{-102,-6}}, color={0,0,127}));
  connect(souDis.ports[1], TDisSup.port_a)
    annotation (Line(points={{-80,-10},{-60,-10}}, color={0,127,255}));
  connect(TDisSup.port_b, coo.port_a1)
    annotation (Line(points={{-40,-10},{-30,-10},{-30,-44},{-10,-44}}, color={0,127,255}));
  connect(QCoo.y[1], division.u1)
    annotation (Line(points={{-59,90},{-2,90}}, color={0,0,127}));
  connect(Q_flow_max.y, division.u2)
    annotation (Line(points={{-19,78},{-2,78}}, color={0,0,127}));
  connect(division.y, val.y)
    annotation (Line(points={{21,84},{130,84},{130,2}}, color={0,0,127}));
  connect(QCoo.y[1], pro.u1)
    annotation (Line(points={{-59,90},{-50,90},{-50,62},{38,62}}, color={0,0,127}));
  connect(ram.y, pro.u2)
    annotation (Line(points={{-59,50},{38,50}}, color={0,0,127}));
  connect(loa.u, pro.y)
    annotation (Line(points={{78,-4},{70,-4},{70,56},{61,56}},color={0,0,127}));
  connect(coo.port_b1, TBuiSup.port_a)
    annotation (Line(points={{10,-44},{30,-44},{30,-10},{40,-10}}, color={0,127,255}));
  connect(TBuiSup.port_b, loa.port_a)
    annotation (Line(points={{60,-10},{80,-10}}, color={0,127,255}));
  connect(loa.port_b, val.port_a)
    annotation (Line(points={{100,-10},{120,-10}}, color={0,127,255}));
  connect(val.port_b, TBuiRet.port_a)
    annotation (Line(points={{140,-10},{150,-10},{150,-90},{60,-90}}, color={0,127,255}));
  connect(TBuiRet.port_b, coo.port_a2)
    annotation (Line(points={{40,-90},{30,-90},{30,-56},{10,-56}}, color={0,127,255}));
  connect(coo.port_b2, TDisRet.port_a)
    annotation (Line(points={{-10,-56},{-30,-56},{-30,-90},{-40,-90}}, color={0,127,255}));
  connect(TDisRet.port_b, sinDis.ports[1])
    annotation (Line(points={{-60,-90},{-80,-90}}, color={0,127,255}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-120},{160,120}})),
    __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/Examples/CoolingDirectUncontrolled.mos"
    "Simulate and plot"),
  experiment(
    StartTime=0,
    StopTime=86400,
    Tolerance=1e-03),
    Documentation(info="<html>
<p>This model provides an example for the direct cooling energy transfer station model, which
does not contain in-building pumping or deltaT control. The ultimate control lies with 
the thermostatic control valve at the lumped, terminal building load. The control valve is 
modulated proportionally to the instantaneous cooling load with respect to the maxiumum load.
</p>
</html>", revisions="<html>
<ul>
<li>November 13, 2019, by Kathryn Hinkelman:<br>First implementation. </li>
</ul>
</html>"));
end CoolingDirectUncontrolled;
