interface IImplementation {
	(): {
		onBeforeRender?: (deltaTime: number, worldModel: Model) => void;
		onRemoved?: (
			worldPart: Part,
			viewportPart: Part,
			highlight: IHighlight,
		) => void;
		onRender: (
			deltaTime: number,
			worldPart: Part,
			viewportPart: Part,
			highlightState: IHighlight,
		) => void;
		onAdded?: (
			worldPart: Part,
			viewportPart: Part,
			highlight: IHighlight,
		) => void;
	};
}

interface IImplementations {
	worldColor: IImplementation;
	highlightColor: IImplementation;
}

declare interface IHighlight {
	readonly target: Model;
	color: Color3;
	transparency: number;
}

declare class Renderer {
	addToStack(highlight: IHighlight): void;
	removeFromStack(highlight: IHighlight): void;
	withRenderImpl(implementationFunc: IImplementation): Renderer;
	step(deltaTime: number): void;
}

declare namespace ObjectHighlighter {
	function createFromTarget(model: Model): IHighlight;
	function createRenderer(screenGui: ScreenGui): Renderer;
	const Implementations: IImplementations;
}

export = ObjectHighlighter;
