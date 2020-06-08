within Buildings.Occupants.Office.Lighting;
model Gunay2016Light
  "A model to predict occupants' lighting behavior with illuminance"
  extends Modelica.Blocks.Icons.DiscreteBlock;
  parameter Real AArriv=-0.009
    "Slope of logistic regression arrival";
  parameter Real BArriv=1.6
    "Intercept of logistic regression arrival";
  parameter Real AInter=-0.002
    "Slope of logistic regression intermediate";
  parameter Real BInter=-3.9
    "Intercept of logistic regression intermediate";
  parameter Integer seed=30
    "Seed for the random number generator";
  parameter Modelica.SIunits.Time samplePeriod=120
    "Sample period";
  Modelica.Blocks.Interfaces.RealInput ill
    "Illuminance on the working planein units of lux"
    annotation(Placement(transformation(extent={{-140,-80}, {-100,-40}}), iconTransformation(extent={{-140,-80}, {-100,-40}})));
  Modelica.Blocks.Interfaces.BooleanInput occ
    "Indoor occupancy, true for occupied"
    annotation(Placement(transformation(extent={{-140, 40}, {-100, 80}})));
  Modelica.Blocks.Interfaces.BooleanOutput on
    "State of lighting"
    annotation(Placement(transformation(extent={{100,-10}, {120, 10}})));
  Real pArriv(final unit="1", final min=0, final max=1)
    "Probability of switch on the lighting upon arrival";
  Real pInter(final unit="1", final min=0, final max=1)
    "Intermediate robability of switch on the lighting";
protected
  parameter Modelica.SIunits.Time t0(final fixed=false)
    "First sample time instant";
  output Boolean sampleTrigger
    "True, if sample time instant";
  Real curSeed
    "Current value for seed as a real-valued variable";
initial equation
  t0=time;
  curSeed=t0*seed;
  on=false;
equation
  pArriv=Modelica.Math.exp(AArriv*ill + BArriv)/(1 + Modelica.Math.exp(AArriv*ill + BArriv));
  pInter=Modelica.Math.exp(AInter*ill + BInter)/(1 + Modelica.Math.exp(AInter*ill + BInter));
  sampleTrigger=sample(t0, samplePeriod);
  when {occ, sampleTrigger} then
    curSeed=seed*time;
    if sampleTrigger then
      if occ then
        if not pre(on) then
          on=Buildings.Occupants.BaseClasses.binaryVariableGeneration(p=pInter, globalSeed=integer(curSeed));
        else
          on=true;
        end if;
      else
        on=false;
      end if;
    else
      on=Buildings.Occupants.BaseClasses.binaryVariableGeneration(p=pArriv, globalSeed=integer(curSeed));
    end if;
  end when;
  annotation(Icon(graphics={Rectangle(extent={{-60, 40}, {60,-40}}, lineColor={28, 108, 200}), Text(extent={{-40, 20}, {40,-20}}, lineColor={28, 108, 200}, fillColor={0, 0, 255}, fillPattern=FillPattern.Solid, textStyle={TextStyle.Bold}, textString="Light_Illu")}), defaultComponentName="lig", Documentation(info="<html>
<p>
Model predicting the state of the lighting with the illuminance on the working plane
and occupancy.
</p>
<h4>Dynamics</h4>
<p>
When the space is unoccupied, the light is always off. When the
space is occupied, the probability to switch on the light depends
on the illuminance level on the working plane. The lower the
illuminance level, the higher the chance to switch on the lighting.
</p>
<p>
The probability to switch on the lighting is different when subjects just arrived and when
subjects have stayed indoor for a while. The probability to switch lights is higher when
subjects just arrived. Accordingly, two different probability functions
have been applied.
</p>
<p>
The switch-off probability is found to be very low in this research, which
may be because occupants failed to notice the lighting is on when the indoor
daylight illuminance levels were high. Therefore, in this model, the lighting would
be switched off only when the space is unoccupied.
</p>
<h4>References</h4>
<p>
The model is documented in the paper &quot;Gunay, H.B., O'Brien, W. and Beausoleil-Morrison, I.,
2016. Implementation and comparison of existing occupant behaviour models in EnergyPlus.
Journal of Building Performance Simulation, 9(6), pp.567-588.&quot;
</p>
<p>
The model parameters are utilized as inputs for the lighting behavior models developped by
Gunay et al.
</p>
</html>", revisions="<html>
<ul>
<li>
July 27, 2018, by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Gunay2016Light;
