interface IImplementation {
	(): {
		onBeforeRender?: (deltaTime: number, worldModel: Model) => void;
		onRemoved?: (
			worldPart: Part,
			viewportPart: Part,
			highlight: Highlight,
		) => void;
		onRender: (
			deltaTime: number,
			worldPart: Part,
			viewportPart: Part,
			highlightState: Highlight,
		) => void;
		onAdded?: (
			worldPart: Part,
			viewportPart: Part,
			highlight: Highlight,
		) => void;
	};
}

interface IImplementations {
	worldColor: IImplementation;
	highlightColor: IImplementation;
}

declare class Highlight {
	readonly target: Model;
	color: Color3;
	transparency: number;
}

declare class Renderer {
	addToStack(highlight: Highlight): void;
	removeFromStack(highlight: Highlight): void;
	withRenderImpl(implementationFunc: IImplementation): Renderer;
	step(deltaTime: number): void;
}

declare namespace ObjectHighlighter {
	function createFromTarget(model: Model): Highlight;
	function createRenderer(screenGui: ScreenGui): Renderer;
	const Implementations: IImplementations;
}

export = ObjectHighlighter;
