# 彩珠手串的配色计数

用 m 种颜色的珠子穿手串，每串有 n 颗珠子，每种颜色的珠子都足够多。有多少种配色不同的手串？

我用编程的方法，得到了如下数据：

<table cellspacing="0" class="t_table" style="width:50%"><tbody><tr><td colspan="2" rowspan="2" width="8"> </td><td colspan="12"> m种颜色</td></tr><tr><td> 1 </td><td> 2 </td><td> 3 </td><td> 4 </td><td> 5 </td><td> 6 </td><td> 7 </td><td> 8 </td><td> 9 </td><td> 10 </td><td> 11 </td><td> 12 </td></tr><tr><td rowspan="11"><br>
 n<br>
颗<br>
珠<br>
子</td><td> 2 </td><td>1 </td><td>3 </td><td>6 </td><td>10 </td><td>15 </td><td>21 </td><td>28 </td><td> 36</td><td>45 </td><td>55 </td><td>66 </td><td>78</td></tr><tr><td> 3</td><td>1 </td><td> 4</td><td>10 </td><td> 20</td><td>35 </td><td> 56</td><td>84 </td><td> 120</td><td> 165</td><td>220 </td><td>286 </td><td>364 </td></tr><tr><td> 4</td><td>1 </td><td>6 </td><td>21 </td><td> 55</td><td>120 </td><td>231 </td><td>406 </td><td>666 </td><td> 1035</td><td> 1540</td><td>2211 </td><td>3081 </td></tr><tr><td> 5</td><td>1 </td><td>8 </td><td>39 </td><td>136 </td><td> 377</td><td>888 </td><td>1855 </td><td> 3536</td><td>6273 </td><td>10504 </td><td> 16775</td><td> 25752</td></tr><tr><td> 6</td><td> 1</td><td>13 </td><td>92 </td><td>430 </td><td> 1505</td><td>4291 </td><td> 10528</td><td> 23052</td><td> 46185</td><td>86185 </td><td>151756 </td><td>254618</td></tr><tr><td> 7</td><td>1 </td><td>18 </td><td>198 </td><td>1300 </td><td> 5895</td><td>20646 </td><td>60028 </td><td> 151848</td><td>344925 </td><td>719290 </td><td> 1399266</td><td>2569788 </td></tr><tr><td> 8</td><td>1 </td><td> 30</td><td>498 </td><td>4435 </td><td>25395</td><td>107331 </td><td>365260 </td><td>1058058 </td><td>2707245 </td><td>6278140 </td><td>13442286 </td><td> 26942565</td></tr><tr><td> 9</td><td> 1</td><td> 46</td><td> 1219</td><td>15084 </td><td> 110085</td><td>563786 </td><td> 2250311</td><td>7472984 </td><td> 21552969</td><td>55605670 </td><td>131077771 </td><td>286779076 </td></tr><tr><td>10</td><td>1 </td><td> 78</td><td> 3210</td><td>53764 </td><td>493131 </td><td> 3037314</td><td>14158228 </td><td>53762472 </td><td>174489813 </td><td>500280022 </td><td> 1297362462</td><td>3096689388 </td></tr><tr><td>11</td><td>1 </td><td>126 </td><td>8418 </td><td> 192700</td><td>2227275 </td><td>16514106 </td><td> </td><td> </td><td> </td><td> </td><td> </td><td> </td></tr><tr><td>12 </td><td>1 </td><td>224 </td><td>22913 </td><td> 704370</td><td>10196680 </td><td> 90782986</td><td> </td><td> </td><td> </td><td> </td><td> </td><td> </td></tr></tbody></table>

根据上表数据，外推出 n 小于等于 6 时通项公式：

`\D S(m,2)=\frac{m(m+1)}2`

`\D S(m,3)=\frac{m(m^2+3m+2)}6=\frac{m(m+1)(m+2)}6`

`\D S(m,4)=\frac{m(m^3+2m^2+3m+2)}8=\frac{m(m+1)(m^2+m+2)}8`

`\D S(m,5)=\frac{m(m^4+5m^2+4)}{10}=\frac{m(m^2+1)(m^2+4)}{10}`

`\D S(m,6)=\frac{m(m^5+3m^3+4m^2+2m+2)}{12}=\frac{m(m+1)(m^4-m^3+4m^2+2)}{12}`



<font size="4">可否得到 S (m, n)的二元表达式？</font>

---
Case S(3,4)， 红绿黄三色四珠的手串。每种颜色的珠子都足够多，用它们穿手串，那么共有 21 种不同色配的手串，全谱图如下。

谱图中任意一条手串，无论怎样旋转、翻面，都不会跟谱图中别的手串完全一样。

任一红绿黄四珠手串，经适当地旋转、翻面，一定会跟谱图中某个手串完全相同。







---
需要引用一下**带有重复元素的圆排列和环排列**相关知识。



下面内容引自 常新德 永城职业学院《有重复元素的圆排列和环排列的计数问题》



记 `k\,(k\geqslant 1)` 重集 `S=\{n_1\*e_1,n_2\*e_2,\cdots,n_k\*e_k\}`，其中 `e_i,\,n_i\;(i=1,2,\dots,k)`分别为元素以及相应的重复数，且集合的势 `|S|=n_1+n_2+\cdots+n_k=n`. 那么该集合所有元素的

1）圆排列数为$$ Q(S)=\frac{1}{n}\sum_{d|(n_1,\cdots,n_k)}\varphi(d)\frac{(\frac{n}{d})!}{\Pi_{i=1}^k(\frac{n_i}{d})!}$$其中 `\varphi(x)` 为数论中的欧拉函数，`(n_1,\cdots,n_k)` 表示 `n_1,n_2,\cdots,n_k` 的最大公约数。

2）环排列数为$$R(S)=\frac{Q(S)+M(S)}{2}$$其中，`\D M(S)=\frac{\left(\sum_{i=1}^k [n_i/2]\right)!}{\Pi_{i=1}^k [n_i/2]!}` 为对称圆排列数，`[x]` 为高斯函数（表示 `x` 的整数部分）。

注意：**环排列**和**圆排列**，概念有细微区别。环排列考虑旋转不变且翻转不变，而圆排列考虑的是旋转不变。



现在，假定有`c`种`k`重集，那么楼主的手串总数就是\[\D S(m,n)=\sum^m_{k=1}\sum^c_{i=1}C^k_mR(S_i)\]问题分三步进行：

1. 求线性不定方程 `x_1+x_2+\cdots+x_m=n` 的非负整数解（共 `C_{n+m-1}^{m-1}` 组解）。

2. 对任一组解`(n_1,n_2,\cdots,n_m)`, 计算相应的重集 `S_i=\{n_1\*e_1,n_2\*e_2,\cdots,n_m\*e_m\}`的环排列数`R(S_i)`。

3. 将这些环排列数相加，`\D S(m,n)=\sum^c_{i=1}R(S_i)`。（这与上面的汇总公式不同，是因为这里第1步中允许`x_i`取0，`c=C_{n+m-1}^{m-1}`）



不知楼主那个公式是怎么得到的？

---
看了下《有重复元素的圆排列和环排列的计数问题》这篇论文。我们的问题跟论文说的问题，还是有差别的。

在本主题中，各色珠子的个数分配不是固定的，而上述论文中，各元素的重数是已知、固定的。

论文中讲了一个红黄各四穿成八珠手串共 8 种的例子，见下图。

这显然只是跟我们所要求的 S(2,8) 的一部分。

![](https://bbs.emath.ac.cn/data/attachment/forum/201610/27/135509zf8wiqdwdw3d28od.png)


---
关于主帖中那些公式是如何得到的？我是观察列表，发现每一行都呈 n 阶等差数列，猜想就是 n 阶等差数列，用待定系数法就可以得到数列的一个通项公式，也就是主帖中的那些公式。

《有重复元素的圆排列和环排列的计数问题》论文中说的方法，我看不明白。我想，也许可求得 S(m, n) 的二元表达式，或者至少是一个算法能够算出 S(m, n) 的值。

---
[https://en.wikipedia.org/wiki/P%C3%B3lya_enumeration_theorem](https://en.wikipedia.org/wiki/P%C3%B3lya_enumeration_theorem)

---
又推出了S(m,7), S(m,8)的公式。

`\D S(m,7)=\frac{m(m^6+7m^3+6)}{14}`

`\D S(m,8)=\frac{m(m^7+4m^4+5m^3+2m+4)}{16}`

---
S(2,n)=[A000029](http://oeis.org/A000029)(n)

S(3,n)=[A027671](http://oeis.org/A027671)(n)

S(4,n)=[A032275](http://oeis.org/A032275)(n)

S(5,n)=[A032276](http://oeis.org/A032276)(n)

S(6,n)=[A056341](http://oeis.org/A056341)(n)

S(7,n)=[A032276](http://oeis.org/A032276)(n)



8色及以上的手链或手串数[OEIS](http://oeis.org/)尚未收录，楼主若搞出结果来，可以申报上去。



S(m,9)=[A060561](http://oeis.org/A060561)(n)

S(m,10)=[A060562](http://oeis.org/A060562)(n)

---
用伯恩赛德引理（Burnside's lemma，波利亚计数定理就是用它推导得来的）就能得到如下结论：

对于 `m` 个颜色可重复地选取 `n` 个排成一圈，圆排列数为$$N(m,n)=\frac{1}{n}\sum_{i=1}^n m^{(n,i)}$$环排列数为

$$
M(m,n)=N(m,n)/2+\begin{cases}\dfrac{m^{k+1}}{2},&n=2k+1\\

\dfrac{(m+1)m^k}{4},&n=2k

\end{cases}
$$

经验证，符合1楼所给的经验公式。

---
对于`n`是一个奇素数` p` 的情况，我暗暗猜测的蒙对了。![](https://bbs.emath.ac.cn/)




`\D S(m,p)=\frac{m(m^{\frac{p-1}2}+p-1)(m^{\frac{p-1}2}+1)}{2p}`

---
