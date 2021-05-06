.global lab4
.syntax unified

#define X1 #-9
#define X2 #10
#define X3 #31
#define X4 #-21

lab4:
  push {lr}
  bl task1
  bl task2
  pop {pc}

task1:
  push {lr}
  mov r0, X1
  mov r1, #0xFFFFFFFF

  mov r2, X2
  mov r3, #0

  mov r4, X3
  mov r5, #0

  mov r6, X4
  mov r7, #0xFFFFFFFF

  // Variant 011: 4*(X1 / 2 + X2) - (X3 + 1 - X4) / 4
  
  // X1 / 2
  asr r0, #1
  lsr r1, #1
  
  // X1 / 2 + X2
  add r0, r2
  adc r1, r3
  
  // 4 * (X1 / 2 + X2)
  lsl r0, #2
  lsl r1, #2
  
  // X3 + 1
  add r4, #1
  adc r5, #1
  
  // X3 + 1 - X4
  sub r4, r6
  sbc r5, r7

  // (X3 + 1 - X4) / 4
  asr r4, #2
  lsr r5, #2

  // 4*(X1 / 2 + X2) - (X3 + 1 - X4) / 4
  sub r0, r4
  sbc r1, r5
  
  bl result_correction
  pop {pc}
  
// Result correction
result_correction:
  push {lr}
  bvc step2
  lsr r0, #1
  lsr r1, #1
step2:
  orr r0, #0
  bne step4
  orr r1, #0
  bne step4
  mov r0, #0b00100011
step4:
  add r1, #0b00100011
  and r5, r1, #0xc0000000
  beq step7
  eor r5, #0xc0000000
  beq step7
  lsr r0, #1
  lsr r1, #1
step7:
  bvs end_correction
  push {r0}
  push {r1}
  pop {r1}
  pop {r0}

end_correction:
  pop {pc}

task2:
  push {lr}

  mov r1, #20
  mov r2, #8

first_program:
  // 1: r0 = r1 + r2
  add r0, r1, r2
  
  // 2: r0 = r1 - r2
  sub r0, r1, r2
  
  
label_3:
  // 3: r0 = r1 * r2
  mul r0, r1, r2
  
  // 4: label_1
  bvc label_1
  
  // 6: r0 = r1 + r2
  add r0, r1, r2
  
  b label_2
label_1:
  // 5: r0 = r0 + 35
  add r0, #35
  
  bl second_program
  // 7: r1 = r1 - 15
  sub r1, #15
label_2:
  // 8: label_3
  beq label_3
  
  // 9: r0 = r0 & r1
  and r0, r1
  pop {pc}

second_program:
  push {lr}
label_5:
  // 10: r2 = r2 + 45
  add r2, #45
  
  // 11: label_4
  bcs label_4
  
  
  // 12: r1 = r1 ^ r2 
  eor r1, r2
label_4:
  // 13: label_5
  bvs label_5
  bl third_program  

  // 14: r0 = r1 + r2
  add r0, r1, r2
  
  // 15: r0 = r1 - r2
  sub r0, r1, r2
  
  pop {pc}

third_program:
  push {lr}
  
  // 17: r0 = r1 + r2
  adds r0, r1, r2
  
  // 18: r0 = r2 / r1
  udiv r0, r2, r1
  
  pop {pc}