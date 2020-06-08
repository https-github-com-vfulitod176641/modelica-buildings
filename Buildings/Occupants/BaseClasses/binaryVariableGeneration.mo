within Buildings.Occupants.BaseClasses;
function binaryVariableGeneration
  "Binary variables random generator"
  input Real p(min=0, max=1)
    "Probaility of 1";
  input Integer globalSeed
    "Seed for the random number generator";
  output Boolean y
    "Random number";
protected
  Integer localSeed
    "Local seed";
  Integer state[Modelica.Math.Random.Generators.Xorshift1024star.nState];
  Real r(min=0, max=1)
    "Generated random number";
algorithm
  state := Modelica.Math.Random.Generators.Xorshift1024star.initialState(localSeed, globalSeed);
  (r, state) := Modelica.Math.Random.Generators.Xorshift1024star.random(state);
  y := r < p;
  annotation(Documentation(info="<html>
<p>
Function that generates a random binary variable with the input of probability <code>p</code>.
</p>
<p>
The input <code>p</code> denotes the probability of being <code>true</code>.
Higher <code>p</code> indicates a higher chance of generating <code>true</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 20, 2018, by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end binaryVariableGeneration;
