export function decodeDC(value) {
	const intR = value >> 16;
	const intG = (value >> 8) & 255;
	const intB = value & 255;
	return { r: sRGBToLinear(intR) * 255, g: sRGBToLinear(intG) * 255, b: sRGBToLinear(intB) * 255 };
}

export function decode83(str) {
	let value = 0;
	for (let i = 0; i < str.length; i++) {
		const c = str[i];
		const digit = digitCharacters.indexOf(c);
		value = value * 83 + digit;
	}
	return value;
}

function sRGBToLinear(value) {
	const v = value / 255;
	if (v <= 0.04045) return v / 12.92;
	else return Math.pow((v + 0.055) / 1.055, 2.4);
}

const digitCharacters = [
	'0',
	'1',
	'2',
	'3',
	'4',
	'5',
	'6',
	'7',
	'8',
	'9',
	'A',
	'B',
	'C',
	'D',
	'E',
	'F',
	'G',
	'H',
	'I',
	'J',
	'K',
	'L',
	'M',
	'N',
	'O',
	'P',
	'Q',
	'R',
	'S',
	'T',
	'U',
	'V',
	'W',
	'X',
	'Y',
	'Z',
	'a',
	'b',
	'c',
	'd',
	'e',
	'f',
	'g',
	'h',
	'i',
	'j',
	'k',
	'l',
	'm',
	'n',
	'o',
	'p',
	'q',
	'r',
	's',
	't',
	'u',
	'v',
	'w',
	'x',
	'y',
	'z',
	'#',
	'$',
	'%',
	'*',
	'+',
	',',
	'-',
	'.',
	':',
	';',
	'=',
	'?',
	'@',
	'[',
	']',
	'^',
	'_',
	'{',
	'|',
	'}',
	'~',
];
