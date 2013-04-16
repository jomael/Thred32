unit Thred_Defaults; {to avoid error: "curcilar refence" between Constants.pas & Types.pas}

interface

uses
  Thred_Types, Thred_Constants;

const

  defCol : T16Colors =( //thred.cpp 838
    $000000,
    $800000,
    $FF0000,
    $808000,
    $FFFF00,
    $800080,
    $FF00FF,
    $000080,
    $0000FF,
    $008000,
    $00FF00,
    $008080,
    $00FFFF,
    $808080,
    $C0C0C0,
    $FFFFFF
  );
  
  //default user color
  DEFAULT_USER_COLORS{defUseCol}: T16Colors =(
    $00000000,
    $002dffff,
    $003f87e9,
    $000762f8,
    $000000ff,
    $002f03af,
    $007248b7,
    $00ff0080,
    $00920166,
    $00a00000,
    $00ff2424,
    $006a4d15,
    $00f5800a,
    $004b7807,
    $00156a1e,
    $00dbe6e3
  );

  DEFAULT_CUSTOM_COLORS{defCustCol} : T16Colors =(
    $729674,
    $1a1eb9,
    $427347,
    $bfff,
    $d3c25f,
    $c3ced0,
    $4a8459,
    $8cacd0,
    $81aeb6,
    $7243a5,
    $bdadda,
    $9976c5,
    $96d9f5,
    $e2ddd6,
    $245322,
    $7b60ae
  );

  DEFAULT_BACK_CUSTOM_COLORS{defBakCust} : T16Colors =(
    $a3c5dc,
    $adc7b6,
    $d1fcfb,
    $dcd7c0,
    $ebddcd,
    $c6b3b3,
    $dec9ce,
    $d2d1e9,
    $dfdffd,
    $bee6ef,
    $8fb8b1,
    $85c2e0,
    $abc1c9,
    $d3d3c7,
    $7c9c84,
    $9acddc
  );

  DEFAUL_BITMAP_COLORS{defBakBit} : T16Colors =(

    $c0d5bf,
    $c8dfee,
    $708189,
    $a5a97a,
    $b8d6fe,
    $8a8371,
    $4b6cb8,
    $9cdcc2,
    $366d39,
    $dcfcfb,
    $3c4f75,
    $95b086,
    $c9dcba,
    $43377b,
    $b799ae,
    $54667a
  );

  namloc: array[0..49] of Cardinal= (
    999,	//0
    1024,	//1
    2,		//2
    2051,	//3
    2050,	//4
    5,		//5
    7,		//6
    1,		//7
    17,		//8
    9,		//9
    2058,	//10
    11,		//11
    51,		//12
    6,		//13
    14,		//14
    2055,	//15
    8,		//16
    2056,	//17
    18,		//18
    2057,	//19
    10,		//20
    21,		//21
    22,		//22
    23,		//23
    99,		//24
    3075,	//25
    26,		//26
    2075,	//27
    28,		//28
    2062,	//29
    30,		//30
    63,		//31
    65,		//32
    132,	//33
    68,		//34
    2083,	//35
    36,		//36
    37,		//37
    311,	//38
    3081,	//39
    80,		//40
    41,		//41
    42,		//42
    43,		//43
    1035,	//44
    1547,	//45
    3800,	//46
    47,		//47
    96,		//48
    2054	//49
  );
implementation

end.
