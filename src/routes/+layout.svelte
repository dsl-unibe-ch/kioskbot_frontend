<script lang="ts">
	import '../app.css';
	import Logo from '$lib/img/logo_unibern@2x.png';

	let { children } = $props();
</script>

<div class="m-2 flex min-h-lvh flex-col justify-between sm:mx-4">
	<header><img src={Logo} alt="Logo Universität Bern" /></header>
	<main class="@container/main container mx-auto flex flex-col">
		{@render children()}
	</main>
	<footer></footer>
</div>

<style>
	header img {
		width: 100%;
		max-width: 180px;
	}
</style>
