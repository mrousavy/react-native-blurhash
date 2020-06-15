"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const react_1 = __importDefault(require("react"));
const react_native_1 = require("react-native");
class BlurhashView extends react_1.default.Component {
    constructor(props) {
        super(props);
    }
    render() {
        return (<Blurhash {...this.props}/>);
    }
}
// requireNativeComponent automatically resolves 'BlurhashView' to 'BlurhashViewManager'
const Blurhash = react_native_1.requireNativeComponent('BlurhashView');
exports.default = Blurhash;
