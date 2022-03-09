// Some functions from the Blurhash JS implementation that are used for light tasks (such as getting the average color or validating if a blurhash string is valid)

export interface RGB {
	/**
	 * The Red value component of this RGB instance. Ranges from 0 to 255.
	 */
	r: number;
	/**
	 * The Green value component of this RGB instance. Ranges from 0 to 255.
	 */
	g: number;
	/**
	 * The Blue value component of this RGB instance. Ranges from 0 to 255.
	 */
	b: number;
}

function sRGBToLinear(value: number): number {
	const v = value / 255;
	if (v <= 0.04045) return v / 12.92;
	else return Math.pow((v + 0.055) / 1.055, 2.4);
}

export function decodeDC(value: number): RGB {
	const intR = value >> 16;
	const intG = (value >> 8) & 255;
	const intB = value & 255;
	return { r: sRGBToLinear(intR) * 255, g: sRGBToLinear(intG) * 255, b: sRGBToLinear(intB) * 255 };
}

export function decode83(str: string): number {
	let value = 0;
	for (let i = 0; i < str.length; i++) {
		const c = str[i];
		const digit = digitCharacters.indexOf(c);
		value = value * 83 + digit;
	}
	return value;
}

function validateBlurhash(blurhash: string): void {
	if (!blurhash || blurhash.length < 6) throw new Error('The blurhash string must be at least 6 characters');

	const sizeFlag = decode83(blurhash[0]);
	const numY = Math.floor(sizeFlag / 9) + 1;
	const numX = (sizeFlag % 9) + 1;

	if (blurhash.length !== 4 + 2 * numX * numY)
		throw new Error(`blurhash length mismatch: length is ${blurhash.length} but it should be ${4 + 2 * numX * numY}`);
}

export function isBlurhashValid(blurhash: string): { isValid: true } | { isValid: false; errorReason: string } {
	try {
		validateBlurhash(blurhash);
	} catch (error) {
		const message = error instanceof Error ? error.message : JSON.stringify(error);
		return { isValid: false, errorReason: message };
	}

	return { isValid: true };
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
