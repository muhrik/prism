gsmp//Rmin=? [ F (target) ] {(t1,1,0.00000000000001..10), (t2,1,0.00000000000001..10)}

// cost in states
const double WAITING_COST=1;

const double TIMEOUT_COST=1;

const double request = 1;
const double answer  = 1;
const double loss    = 0.1;
const double break   = 0.1;

// number of components - 1
const int max_u = 1;

// target states
label "target" = target;
formula target = num_finished = max_u + 1;
formula num_finished = ((s1=3)?1:0) + ((s2=3)?1:0);
formula unfinished = max_u+1-num_finished;


rewards 
	 ! target : WAITING_COST;

	[f1] true : TIMEOUT_COST;
	[f2] true : TIMEOUT_COST;
endrewards

module synchro

event t1 = dirac(2.0);
event t2 = dirac(2.0);

	s1 : [0..3] init 1;
	s2 : [0..3] init 1;
	// 0 lost
	// 1 requesting
	// 2 waiting for answer
	// 3 synchronized

	u : [0..max_u] init 0; 
	// number of finished
	
	[] (s1=1) -> request: (s1'=2);
	[] (s1=2) -> answer : (s1'=3);
	[] (s1<3) -> loss   : (s1'=0);
	[] (s1=3)&!target  -> break  : (s1'=1);

	[] (s2=1) -> request: (s2'=2);
	[] (s2=2) -> answer : (s2'=3);
	[] (s2<3) -> loss   : (s2'=0);
	[] (s2=3)&!target  -> break  : (s2'=1);

        //deadlock state
        [] target -> 1: (s1'=s1);

	// last the last but 1
	[f1] !target & (u=0) --t1-> 1: (s1'=1) & (s2'=unfinished>=2?1:3) & (u'=num_finished);
	[f2] !target & (u=1) --t2-> 1: (s1'=1) & (s2'=unfinished>=2?1:3) & (u'=num_finished);

endmodule


