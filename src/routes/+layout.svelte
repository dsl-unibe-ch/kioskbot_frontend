<script lang="ts">
	import { ModeWatcher } from 'mode-watcher';
	import '../app.css';

	let { children } = $props();
</script>

<ModeWatcher />
<div class="flex min-h-lvh flex-col justify-between">
	<header>unibe logo</header>
	<main class="@container/main container mx-auto flex flex-col">
		{@render children()}
	</main>
	<footer>
		<p>KioskBot</p>
	</footer>
</div>
