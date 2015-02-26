within Buildings.Fluid.FMI.Examples.FMUs;
block ResistanceVolume
  "Container to export a flow resistance and control volume as an FMU"
  extends TwoPort(redeclare package Medium = Buildings.Media.Air);

  parameter Modelica.SIunits.Volume V=1 "Volume";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 0.1
    "Nominal mass flow rate";
  parameter Modelica.SIunits.Pressure dp_nominal = 100 "Nominal pressure drop";

  Modelica.Blocks.Math.Feedback pOut "Pressure at component outlet"
    annotation (Placement(transformation(extent={{10,-70},{30,-50}})));

protected
  Inlet bouIn(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal) "Boundary model for inlet"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Outlet bouOut(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal) "Boundary component for outlet"
    annotation (Placement(transformation(extent={{68,-10},{88,10}})));

  FixedResistances.FixedResistanceDpM res(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal,
    allowFlowReversal=allowFlowReversal) "Flow resistance"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    nPorts=2,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    allowFlowReversal=allowFlowReversal,
    V=V,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) "Control volume"
    annotation (Placement(transformation(extent={{10,0},{30,20}})));
public
  Modelica.Blocks.Sources.RealExpression dpCom(y=res.port_a.p - res.port_b.p)
    "Pressure drop of the component"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
equation
  connect(inlet, bouIn.inlet) annotation (Line(
      points={{-110,0},{-81,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(bouOut.outlet, outlet) annotation (Line(
      points={{89,0},{110,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pOut.u1, bouIn.p) annotation (Line(
      points={{12,-60},{-70,-60},{-70,-11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pOut.y, bouOut.p) annotation (Line(
      points={{29,-60},{78,-60},{78,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(res.port_b, vol.ports[1]) annotation (Line(
      points={{-20,0},{18,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bouIn.port_b, res.port_a) annotation (Line(
      points={{-60,0},{-40,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpCom.y, pOut.u2) annotation (Line(
      points={{-19,-80},{20,-80},{20,-68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vol.ports[2], bouOut.port_a) annotation (Line(
      points={{22,0},{68,0}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
Documentation(info="<html>
<p>
This example demonstrates how to export an FMU with a
flow resistance and a control volume.
The FMU has an instance of
<a href=\"modelica://Buildings.Fluid.FixedResistances.FixedResistanceDpM\">
Buildings.Fluid.FixedResistances.FixedResistanceDpM</a> and
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolume\">
Buildings.Fluid.MixingVolumes.MixingVolume</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
November 8, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Examples/FMUs/ResistanceVolume.mos"
        "Export FMU"),
    Icon(graphics={
        Rectangle(
          extent={{-64,24},{-6,-26}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,14},{100,-16}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
                              Ellipse(
          extent={{18,32},{84,-34}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={170,213,255})}));
end ResistanceVolume;
