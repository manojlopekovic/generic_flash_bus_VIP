[33mcommit 3d0d82716b711c047528c7c89a651ca4b18478ba[m[33m ([m[1;36mHEAD -> [m[1;32mmaster[m[33m, [m[1;31morigin/master[m[33m)[m
Author: Manojlo Pekovic <manojlop@veri-xn123.qb.veriest>
Date:   Wed May 15 14:25:10 2024 +0300

    Added clock agent and integrated it

[33mcommit 033e9bea38df2aade1aeb47fc873280b6f04d66e[m
Author: Manojlo Pekovic <manojlop@veri-xn123.qb.veriest>
Date:   Wed May 15 12:08:29 2024 +0300

    Succesfully integrated reset agent

[33mcommit 4a7b7ba49ea81912ea6f9622cd67376101156d75[m
Author: Manojlo Pekovic <manojlop@veri-xn123.qb.veriest>
Date:   Tue May 14 13:47:08 2024 +0300

    Added specific sequences for each command. Now running all master side sequences from virtual command by invoking these

[33mcommit cf13d7b4832944db85f9696ec5ce326d94a593f1[m
Author: Manojlo Pekovic <manojlop@veri-xn123.qb.veriest>
Date:   Tue May 14 12:27:28 2024 +0300

    Added comparison to scoreboard

[33mcommit 554a1a0235c86070855d9c14d10e2d5aec5abbce[m
Author: Manojlo Pekovic <manojlop@veri-xn123.qb.veriest>
Date:   Tue May 14 12:13:34 2024 +0300

    Connected scoreboard with monitors

[33mcommit b72c94d5a47844e2e4de374bc0bdf078ccd3da44[m
Author: Manojlo Pekovic <manojlop@veri-xn123.qb.veriest>
Date:   Tue May 14 12:09:17 2024 +0300

    Added support when transaction is confirmed, aborted immediately on abort

[33mcommit 69b06bffd36581955a2fe9b3d49d5961b0f4d10c[m
Author: Manojlo Pekovic <manojlop@veri-xn123.qb.veriest>
Date:   Tue Apr 30 11:35:16 2024 +0300

    Added abort checkers and fixed abort handling in driver. Now all monitor checkers should be in place

[33mcommit 2a92113bf373eff35656382e8587eabae7dc8e32[m
Author: Manojlo Pekovic <manojlop@veri-xn123.qb.veriest>
Date:   Thu Apr 25 16:08:04 2024 +0300

    Added IDLE cannot be errored

[33mcommit 131c3ef32911191b69e497d2820567f5e5c2852b[m
Author: Manojlo Pekovic <manojlop@veri-xn123.qb.veriest>
Date:   Thu Apr 25 15:52:09 2024 +0300

    Added error response checher and signal stability checkers in monitors. Signal stability needs to be updated when IDLE->CMD and reset is added

[33mcommit 08c1e274c51717470308483d14f0e302713efe60[m
Author: Manojlo Pekovic <manojlop@veri-xn123.qb.veriest>
Date:   Wed Apr 24 16:33:13 2024 +0300

    Added legal command check in monitor

[33mcommit 9653a4696324f11364f715008efb4b7c8a31e29b[m
Author: Manojlo Pekovic <manojlop@veri-xn123.qb.veriest>
Date:   Wed Apr 24 16:25:03 2024 +0300

    Added address align checker to monitor

[33mcommit 807e4ce3810e56495655e99deda8233feefc9697[m
Author: Manojlo Pekovic <manojlop@veri-xn123.qb.veriest>
Date:   Wed Apr 24 11:56:41 2024 +0300

    Added aborting to both h master driver and monitors. Everything seems to be working correctly

[33mcommit 24314e40e05ec513e5c876a8d6ac771a7dc588c7[m
Author: Manojlo Pekovic <manojlop@veri-xn123.qb.veriest>
Date:   Tue Apr 23 13:01:08 2024 +0300

    Added skeleton for reactive slave, need to implement memort

[33mcommit 800eac5ce00e23310a7acc2c89bb06803892423f[m
Author: Manojlo Pekovic <manojlop@veri-xn123.qb.veriest>
Date:   Tue Apr 23 11:46:08 2024 +0300

    Added base for reactive slave seq

[33mcommit dccb60ee17430f51ee6a823a67d803a715268d72[m
Author: Manojlo Pekovic <manojlop@veri-xn123.qb.veriest>
Date:   Tue Apr 23 11:36:05 2024 +0300

    Driver now drives 'X and correct data, coresponding to command

[33mcommit f9b2cf88824391180de323282ecf95e4bac4505b[m
Author: Manojlo Pekovic <manojlop@veri-xn123.qb.veriest>
Date:   Wed Apr 3 16:36:32 2024 +0300

    Updated driver to drive errors and monitor to sample taking errors into consideration

[33mcommit 8081bdc5d8f670ca5d787a816ce5b14eab70f99c[m
Author: Manojlo Pekovic <manojlop@veri-xn123.qb.veriest>
Date:   Thu Mar 28 17:31:09 2024 +0200

    Added support to that sequence waits for last response

[33mcommit 198b3456b6084a1d735b0ade98131ea78823a3d0[m
Author: Manojlo Pekovic <manojlop@veri-xn123.qb.veriest>
Date:   Thu Mar 28 16:10:06 2024 +0200

    Started on item collection

[33mcommit d099d1e56a1c7404b0810e268df5e17eb33afc53[m
Author: Manojlo Pekovic <manojlop@veri-xn123.qb.veriest>
Date:   Wed Mar 27 12:44:22 2024 +0200

    Updated driver so that now driving happens with waits

[33mcommit d80b72f4fa253d4ab1576b3a466b4bca7b1fe57a[m
Author: Manojlo Pekovic <manojlop@veri-xn123.qb.veriest>
Date:   Wed Mar 27 11:52:20 2024 +0200

    Added fields in item that driver will use for driving interface

[33mcommit e2bc099cdb137e3276a9412b36280c952ec7fee6[m
Author: Manojlo Pekovic <manojlop@veri-xn123.qb.veriest>
Date:   Tue Mar 26 16:19:52 2024 +0200

    Fixed bad driving

[33mcommit 6379e52c00f0007186cbd35ddac7840702083d0c[m
Author: Manojlo Pekovic <manojlop@veri-xn123.qb.veriest>
Date:   Tue Mar 26 15:07:10 2024 +0200

    Added fields and constraints to configuration. Sequence/driver misbehaving, seed: 2

[33mcommit d54284065baf2d632dfca404ec1c10eed0894a74[m
Author: Manojlo Pekovic <manojlop@veri-xn123.qb.veriest>
Date:   Fri Mar 22 13:20:21 2024 +0200

    Implemented master driving logic(two phase). Need to do constraints in item, init drive for correct waves

[33mcommit 52774188ee9e6ca0ebc54eaec1e64a15d3476fff[m
Author: Manojlo Pekovic <manojlop@veri-xn123.qb.veriest>
Date:   Thu Mar 21 13:04:35 2024 +0200

    Added interface signals to interface and item

[33mcommit 11c0fd521ffa8957c2ee0f58202ee0ff3c879918[m
Author: Manojlo Pekovic <manojlop@veri-xn123.qb.veriest>
Date:   Thu Mar 21 12:20:33 2024 +0200

    Added and integrated cfg to all parts of environment. Also added parameters

[33mcommit d9318e69fd282cbe01ac37b6d217bdada0f41d8e[m
Author: Manojlo Pekovic <manojlop@veri-xn123.qb.veriest>
Date:   Thu Mar 21 11:47:55 2024 +0200

    Updated makefile again

[33mcommit d596226130f4ee1fdd57b1f0a0cb44f9ae04e24e[m
Author: Manojlo Pekovic <manojlop@veri-xn123.qb.veriest>
Date:   Thu Mar 21 11:46:38 2024 +0200

    Updated makefile

[33mcommit 530bbf5ae0c8c122ba485aa4498f7eff312736ce[m
Author: Manojlo Pekovic <manojlop@veri-xn123.qb.veriest>
Date:   Mon Mar 18 16:54:40 2024 +0200

    Initial commit
